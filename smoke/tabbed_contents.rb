require "rouge"

class Tabs < Respond::Component
  Props(
    set_demo_active: Method,
    set_code_active: Method,
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
            ) { "Demo" },
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

class CodePanel < Respond::Component
  Props(
    code: String,
  )

  def render
    formatter = Rouge::Formatters::HTML.new
    formatter.format(
      Rouge::Lexers::Ruby.new.lex(
        props.code
      )
    )
  end
end

class TabbedContents < Respond::Component
  Props(
    code: Respond::Component,
    demo: Respond::Component,
  )

  State(
    current_tab: Rbs("'demo' | 'code'"),
  )

  self.initial_state = {
    current_tab: "demo",
  }

  exposed def set_demo_active
    state.current_tab = "demo"
  end

  exposed def set_code_active
    state.current_tab = "code"
  end

  def render
    section(
      Tabs(
        set_demo_active: method(:set_demo_active),
        set_code_active: method(:set_code_active),
        current_tab: state.current_tab,
      ),
      state.current_tab == "code" ? props.code : props.demo,
    )
  end
end
