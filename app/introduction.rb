class Introduction < Quince::Component
  def render
    section(id: :intro) {[
      h2(
        "Welcome to Quince rb"
      ),
      h4(
        "These pages serve to show what Quince's current capabilites, including code examples. ",
        "Take a look around!"
      ),
      hr,
      para(
        "Quince is a new Ruby framework for the web, which allows you to build modern, stateful ",
        "applications, without writing any JavaScript. It inspired by ",
        span(a(href: "https://github.com/facebook/react") { "React" }),
        ", ",
        span(a(href: "https://github.com/hotwired/hotwire-rails") { "Hotwire/Turbo" }),
        ", ",
        span(a(href: "https://github.com/markaby/markaby") { "Markaby" }),
        ", ",
        span(a(href: "https://github.com/camping/camping") { "Camping" }),
        ", and others.",

      ),
      h4("Minimal 'Hello world' example:"),
      CodePanel(const: "HelloWorld"),
      para(
        "It achieves this by providing a rich interface for composing your app from stateful ",
        "components, which are all rendered server-side, and re-rendered and swapped in the front ",
        "end when their state changes. ",
      ),
      blockquote(
        "All of the glue code to make this happen happens internally through ",
        span(code("callback"), "s"),
        ", so you can focus on building your real application content and logic, rather than the ",
        "wiring that keeps it together."
      ),
      CodePanel(const: "Counter"),
      para(
        "In some cases, you may want to be be quite specific about how callbacks are run, instead of ",
        %q{a very basic "click-and-replace" functionality. For instance, you may want to run them },
        "conditionally, or with a debounce, or so that it appends the resulting elements instead of ",
        %q{replacing them. See the "Infinite scroll" demo for an example of how all three of these },
        "things can combine.",
      ),
      h4(
        "Also note that Quince is still in early development, so is likely to be unstable for the first ",
        "few versions. Track versions and releases on ",
        span(
          a(href: "https://rubygems.org/gems/quince") { "Rubygems" }
        ),
        " or ",
        span(
          a(href: "https://github.com/johansenja/quince") { "GitHub" }
        ),
        "."
      )
    ]}
  end
end

class HelloWorld < Quince::Component
  def render
    html(
      head,
      body("Hello world"),
    )
  end
end
