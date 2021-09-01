require_relative "lib/respond_sinatra"

class Layout < Respond::Component
  State(count: Integer)

  self.initial_state = {
    count: 0,
  }

  exposed def reload_footer
    state.count += 1
  end

  def render
    page_title = "My cool app"
    html(
      head(
        title(page_title),
        internal_scripts,
      ),
      body(
        header(
          Navbar(page_title: page_title, reload_footer: method(:reload_footer))
        ),
        children,
        Footer(count: state.count),
      ),
    )
  end
end

class Navbar < Respond::Component
  Props(
    page_title: String,
    reload_footer: Method,
  )

  def render
    nav(
      h1(
        props.page_title
      ),
      ul(
        li("Home"),
        li("About us"),
        li("Contact us"),
      ),
      button(onclick: props.reload_footer) { "Reload footer" },
    )
  end
end

class Footer < Respond::Component
  Props(
    count: Integer,
  )

  def render
    footer(
      a("Link 1"),
      a("Link 2"),
      a("Link 3"),
      para("Reloaded #{props.count} times"),
      div("Copyright etc"),
    )
  end
end

class App < Respond::Component
  def render
    Layout(
      section(
        h2("This is the first section of this page"),
        para(
          "This is a block of text with an ",
          span { i { "important" } },
          " section in it",
        ),
      )
    )
  end
end

expose App, at: "/"
