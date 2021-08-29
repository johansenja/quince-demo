require_relative "lib/respond_sinatra"

class Layout < Respond::Component
  Props(
    page_contents: Respond::Component,
  )

  def render
    page_title = "My cool app"
    html {
      [
        head {
          title { page_title }
        },
        body {
          [
            header {
              Navbar(page_title: page_title)
            },
            children,
            Footer(),
          ]
        },
      ]
    }
  end
end

class Navbar < Respond::Component
  Props(
    page_title: String,
  )

  def render
    nav {
      [
        h1 {
          props.page_title
        },
        ul {
          [
            li { "Home" },
            li { "About us" },
            li { "Contact us" },
          ]
        },
      ]
    }
  end
end

class Footer < Respond::Component
  def render
    footer {
      [
        a { "Link 1" },
        a { "Link 2" },
        a { "Link 3" },
        div { "Copyright etc" },
      ]
    }
  end
end

class App < Respond::Component
  def render
    Layout() {
      [
        section {
          [
            h2 { "This is the first section of this page" },
            para {
              [
                "This is a block of text with an",
                span { i { "important" } },
                "section in it",
              ]
            },
          ]
        },
      ]
    }
  end
end

expose App, at: "/"
