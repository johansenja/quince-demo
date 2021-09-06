require "method_source"

require_relative "../../respond-sinatra/lib/respond_sinatra"
require_relative "show_hide"
require_relative "counter"
require_relative "multi_step_form"
require_relative "tabbed_contents"

class Index < Respond::Component
  def render
    Layout() {
      Content()
    }
  end
end

class Content < Respond::Component
  State(
    page: Rbs("'counter' | 'show_hide' | 'multi_step_form' | Undefined"),
  )

  self.initial_state = {
    page: "counter",
  }

  exposed def set_counter
    state.page = "counter"
  end

  exposed def set_show_hide
    state.page = "show_hide"
  end

  exposed def set_multi_step_form
    state.page = "multi_step_form"
  end

  private def render_li(meth, label, active)
    li(onclick: meth, Class: active ? "active" : Undefined) { label }
  end

  def render
    content = case state.page
      when "counter"
        TabbedContents(
          demo: Counter(),
          code: CodePanel(
            code: MethodSource.source_helper(Object.const_source_location("Counter")),
          ),
        )
      when "show_hide"
        ShowHide()
      when "multi_step_form"
        MultiStepForm()
      when nil, Undefined
        section
      end

    div(
      header(
        h1("Respond component examples"),
      ),
      main(
        nav(
          ul(
            render_li(method(:set_counter), "Increment a counter", state.page == "counter"),
            render_li(method(:set_show_hide), "Show/hide some text", state.page == "show_hide"),
            render_li(method(:set_multi_step_form), "Fill in a multi-step form", state.page == "multi_step_form"),
          )
        ),
        content
      ),
    )
  end
end

class Layout < Respond::Component
  def render
    html(
      head(
        title("Smoke tests"),
        link(href: "/style.css", rel: :stylesheet),
        internal_scripts,
      ),
      body(
        children,
      )
    )
  end
end

expose Index, at: "/"
