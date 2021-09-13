require "method_source"
require "quince_sinatra"

require_relative "app/show_hide"
require_relative "app/counter"
require_relative "app/basic_form"
require_relative "app/tabbed_contents"

class Index < Quince::Component
  def render
    Layout() {
      Content()
    }
  end
end

class Content < Quince::Component
  State(
    page: Rbs("'counter' | 'show_hide' | 'basic_form' | Undefined"),
  )

  def initialize
    @state = State.new(
      page: params.fetch(:page, "counter"),
    )
  end

  exposed def set_counter
    state.page = "counter"
  end

  exposed def set_show_hide
    state.page = "show_hide"
  end

  exposed def set_basic_form
    state.page = "basic_form"
  end

  private def render_li(meth, label, active)
    li(Class: active ? "active" : Undefined) {
      button(onclick: meth) { label }
    }
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
        TabbedContents(
          demo: ShowHide(),
          code: CodePanel(
            code: MethodSource.source_helper(Object.const_source_location("ToggleVisibilitySection")),
          ),
        )
      when "basic_form"
        TabbedContents(
          demo: BasicForm(),
          code: CodePanel(
            code: MethodSource.source_helper(Object.const_source_location("BasicForm")),
          ),
        )
      when nil, Undefined
        section
      end

    div(
      header(
        h1("Quince component examples"),
      ),
      main(
        nav(
          ul(
            render_li(method(:set_counter), "Increment a counter", state.page == "counter"),
            render_li(method(:set_show_hide), "Show/hide some text", state.page == "show_hide"),
            render_li(method(:set_basic_form), "Basic form", state.page == "basic_form"),
            li(button(disabled: true) { "Multi step form - coming soon" }),
            li(button(disabled: true) { "Infinite scroll - coming soon" }),
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
