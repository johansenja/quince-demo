require "rouge"

class Tabs < Quince::Component
  Props(
    set_demo_active: Quince::Callback::Interface,
    set_code_active: Quince::Callback::Interface,
    current_tab: Rbs("'demo' | 'code'"),
  )

  def render
    div(Class: :source_tabs_container) {
      [
        ul(Class: :source_tabs) {
          [
            li(
              onclick: props.set_demo_active,
              Class: props.current_tab == "demo" ? "active" : Undefined,
            ) { "Example" },
            li(
              onclick: props.set_code_active,
              Class: props.current_tab == "code" ? "active" : Undefined,
            ) { "Source code" },
          ]
        },
        hr,
      ]
    }
  end
end

class CodePanel < Quince::Component
  Props(
    const: Quince::Types::OptionalString,
    code: Quince::Types::OptionalString,
  )

  private def get_code
    return props.code unless props.code == Undefined

    MethodSource.source_helper(
      Object.const_source_location(props.const)
    )
  end

  def render
    theme = Rouge::Themes::Gruvbox.new
    formatter = Rouge::Formatters::HTMLInline.new(theme)

    generated_html = formatter.format(
      Rouge::Lexers::Ruby.new.lex(
        get_code
      )
    )

    pre(
      generated_html
    )
  end
end

class TabbedContents < Quince::Component
  Props(
    const: String
  )

  State(
    current_tab: Rbs("'demo' | 'code'"),
  )

  def initialize
    @state = State.new(
      current_tab: "demo",
    )
  end

  exposed def set_demo_active
    state.current_tab = "demo"
  end

  exposed def set_code_active
    state.current_tab = "code"
  end

  def render
    contents = if state.current_tab == "code"
                 section(CodePanel(const: props.const))
               else
                 send props.const
               end
    section(
      Tabs(
        set_demo_active: callback(:set_demo_active),
        set_code_active: callback(:set_code_active),
        current_tab: state.current_tab,
      ),
      div(id: :content_wrapper) {
        contents
      }
    )
  end
end
