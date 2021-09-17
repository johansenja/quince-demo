class SyntaxHighlightingDemo < Quince::Component
  def render
    section {[
      h2(
        "Fully server-generated syntax highlighting"
      ),
      h4("No front end js or css libraries required"),
      hr,
      div(
        para(
          "All of these highlighted sections you see are generated on the fly by ",
          span(
            a(href: "https://github.com/rouge-ruby/rouge") { "rouge" }
          ),
          ", which also adds inline ",
          code("style"),
          " attributes to the generated HTML elements, which means you don't even need to load in",
          " extra stylesheets in the front end."
        ),
        h4(
          "The is what the highlighter component itself looks like (highlighting itself):"
        ),
        div(id: :syntax_highlighting_code_wrapper) {
          CodePanel(
            const: "CodePanel"
          )
        },
        para(
          "Note that it also uses ",
          span(
            a(href: "https://github.com/banister/method_source/") { "method_source" }
          ),
          " to make use of Ruby's introspection features - so it can retrieve the actual source code",
          " when you call it - all you do is have to pass the name of the constant you want to see.",
          " No need to generate any of the previews or rebuild when things change"
        )
      )
    ]}
  end
end
