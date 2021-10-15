require "rqrcode"

class QrCodeGenerator < Quince::Component
  State(
    url: Quince::Types::OptionalString,
  )

  def initialize
    @state = State.new(
      url: nil,
    )
  end

  exposed def set_url
    state.url = params[:url]
  end

  def render
    section(
      form {[
        label(for: :url) { "URL:" },
        br,
        input(
          id: :url,
          name: :url,
          value: state.url,
          onchange: callback(:set_url, take_form_values: true)
        )
      ]},
      state.url ? Code(url: state.url) : nil,
      state.url ? div(
        a(
          href: "#{Code::DOWNLOAD_PATH}?download_as=svg&url=#{CGI.escape(state.url)}",
          Class: "btn",
          download: "code.svg",
        ) {
          "Download as SVG"
        },
        a(
          href: "#{Code::DOWNLOAD_PATH}?download_as=png&url=#{CGI.escape(state.url)}",
          Class: "btn",
          download: "code.png",
        ) {
          "Download as PNG"
        },
      ) : nil,
    )
  end

  class Code < Quince::Component
    DOWNLOAD_PATH = "/qr".freeze
    Props(url: Quince::Types::OptionalString)
    State(url: String, download_as: Rbs("'png' | 'svg' | nil"))

    def initialize
      @state = State.new(
        download_as: params[:download_as],
        url: props.url || params[:url]
      )
    end

    def render
      qr = RQRCode::QRCode.new(state.url)

      case state.download_as
      when "png"
        qr.as_png.to_s
      when "svg"
        qr.as_svg
      else
        qr.as_svg
      end
    end
  end
end

expose QrCodeGenerator::Code, at: QrCodeGenerator::Code::DOWNLOAD_PATH
