require_relative "../../respond-sinatra/lib/respond_sinatra"
require_relative "show_hide"
require_relative "counter"

class Index < Respond::Component
  def render
    Layout() {
      Content()
    }
  end
end

class Content < Respond::Component
  State(
    page: Rbs("'counter' | 'show_hide' | nil"),
  )

  self.initial_state = {
    page: nil,
  }

  exposed def set_counter
    state.page = "counter"
  end

  exposed def set_show_hide
    state.page = "show_hide"
  end

  private def render_li(meth, label, colour)
    li(
      onclick: meth,
      style: "list-style:none;cursor: pointer; border-radius: 4px; padding: 4px 8px; background-color: #{colour}; color: #fee",
    ) { label }
  end

  def render
    content = case state.page
      when :counter
        Counter()
      when :show_hide
        ShowHide()
      when nil
        nil
      end

    [
      header(
        nav(h1 "Choose a page to view")
      ),
      div(
        ul(style: "display: inline-flex") {
          [
            render_li(method(:set_counter), "Increment a counter", "#456"),
            render_li(method(:set_show_hide), "Show/hide some text", "#a6c"),
          ]
        },
        content
      ),
      footer(
        h2 "These pages are listed in smoke/ directory"
      ),
    ]
  end
end

class Layout < Respond::Component
  def render
    html(
      head(
        title("Smoke tests"),
        internal_scripts,
      ),
      body(
        children,
      )
    )
  end
end

expose Index, at: "/"