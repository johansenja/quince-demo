require "method_source"
require "quince"

require_relative "app/show_hide"
require_relative "app/counter"
require_relative "app/basic_form"
require_relative "app/tabbed_contents"
require_relative "app/autocomplete"
require_relative "app/syntax_highlighting"
require_relative "app/introduction"
require_relative "app/infinite_scroll"
require_relative "app/chart"
require_relative "app/qr_code"

class Index < Quince::Component
  def render
    Layout() {
      Content()
    }
  end
end

class Content < Quince::Component
  State(
    page: Rbs(
      ":intro | :counter | :show_hide | :basic_form | :autocomplete | :syntax_highlighting | :infinite_scroll | :chart | :qr_code | nil"
    ),
  )

  def initialize
    @state = State.new(
      page: params.fetch(:page, :intro).to_sym,
    )
  end

  exposed def set_counter
    state.page = :counter
  end

  exposed def set_show_hide
    state.page = :show_hide
  end

  exposed def set_basic_form
    state.page = :basic_form
  end

  exposed def set_autocomplete
    state.page = :autocomplete
  end

  exposed def set_syntax
    state.page = :syntax_highlighting
  end

  exposed def set_intro
    state.page = :intro
  end

  exposed def set_infinite_scroll
    state.page = :infinite_scroll
  end

  exposed def set_chart
    state.page = :chart
  end

  exposed def set_qr_code
    state.page = :qr_code
  end

  private def render_li(clbck, label, page)
    new_param_state = page == :intro ? {} : { page: page }
    li(Class: state.page == page ? :active : nil) {
      button(onclick: callback(clbck, push_params_state: new_param_state)) { label }
    }
  end

  COMPONENT_BY_PAGE_STATE = {
    intro: "Introduction",
    counter: "Counter",
    show_hide: "ToggleVisibilitySection",
    basic_form: "BasicForm",
    autocomplete: "Autocomplete",
    syntax_highlighting: "SyntaxHighlightingDemo",
    infinite_scroll: "InfiniteScroll",
    chart: "ChartExample",
    qr_code: "QrCodeGenerator"
  }.freeze

  def render
    component = COMPONENT_BY_PAGE_STATE[state.page]
    content = component ? TabbedContents(const: component) : section

    div(
      header(
        h1("Quince component examples"),
      ),
      main(
        nav(
          ul(
            render_li(:set_intro, "Introduction", :intro),
            render_li(:set_counter, "Increment a counter", :counter),
            render_li(:set_show_hide, "Show/hide some text", :show_hide),
            render_li(:set_syntax, "Syntax highlighting", :syntax_highlighting),
            render_li(:set_basic_form, "Basic form", :basic_form),
            render_li(:set_autocomplete, "Basic text input autocomplete", :autocomplete),
            render_li(:set_infinite_scroll, "Infinite scroll", :infinite_scroll),
            render_li(:set_chart, "Dynamic charts", :chart),
            render_li(:set_qr_code, "QR code generator (w/ download)", :qr_code),
          ),
          footer(
            a(href: "https://github.com/johansenja/quince", title: "See Quince on GitHub") {
              img(src: "/github_logo_white.png", alt: "GitHub Logo", height: 40, width: 40)
            },
            a(href: "https://rubygems.org/gems/quince", title: "See Quince on RubyGems") {
              img(src: "/rubygems_logo.png", alt: "RubyGems Logo", height: 40, width: 40)
            },
          )
        ),
        content
      ),
    )
  end
end

class Layout < Quince::Component
  def render
    html(
      head(
        title("Quince rb"),
        link(rel: :preconnect, href: "https://fonts.googleapis.com"),
        link(rel: :preconnect, href: "https://fonts.gstatic.com", crossorigin: ""),
        link(href: "https://fonts.googleapis.com/css2?family=PT+Sans&display=swap", rel: :stylesheet),
        link(href: "/style.css", rel: :stylesheet),
        internal_scripts,
        error_message_styles,
      ),
      body(
        children,
      )
    )
  end
end

expose Index, at: "/"
