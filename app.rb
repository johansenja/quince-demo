require "method_source"
require "quince_sinatra"

require_relative "app/show_hide"
require_relative "app/counter"
require_relative "app/basic_form"
require_relative "app/tabbed_contents"
require_relative "app/autocomplete"
require_relative "app/syntax_highlighting"
require_relative "app/introduction"
require_relative "app/infinite_scroll"

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
      ":intro | :counter | :show_hide | :basic_form | :autocomplete | :syntax_highlighting | :infinite_scroll | Undefined"
    ),
  )

  def initialize
    @state = State.new(
      page: params.fetch(:page, :intro),
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

  private def render_li(clbck, label, active)
    li(Class: active ? :active : Undefined) {
      button(onclick: clbck) { label }
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
            render_li(callback(:set_intro), "Introduction", state.page == :intro),
            render_li(callback(:set_counter), "Increment a counter", state.page == :counter),
            render_li(callback(:set_show_hide), "Show/hide some text", state.page == :show_hide),
            render_li(callback(:set_syntax), "Server-rendered syntax highlighting", state.page == :syntax_highlighting),
            render_li(callback(:set_basic_form), "Basic form", state.page == :basic_form),
            render_li(callback(:set_autocomplete), "Basic text input autocomplete", state.page == :autocomplete),
            render_li(callback(:set_infinite_scroll), "Infinite scroll", state.page == :infinite_scroll),
            li(button(disabled: true) { "Multi step form - coming soon" }),
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
      ),
      body(
        children,
      )
    )
  end
end

expose Index, at: "/"
