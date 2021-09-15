class BasicForm < Quince::Component
  State(
    name: String,
    age: Integer,
    favourite_colour: String,
    errors: Rbs("Array[String]"),
    complete: Rbs("true | false"),
  )

  def initialize
    @state = State.new(
      name: "",
      age: 0,
      favourite_colour: "",
      errors: [],
      complete: false,
    )
  end

  exposed def process_form
    name, age, colour = params[:params].values_at(:name, :age, :favourite_colour)
    state.name = name
    state.age = age.to_i
    state.favourite_colour = colour
    errors = []
    errors << "name must be longer than 2" if state.name.length <= 2
    errors << "must be older than 3" if state.age <= 3
    state.errors = errors
    state.complete = errors.empty?
  end

  private def confirmation
    section(
      h4(
        span(
          "Thanks for your submission (name: #{state.name}, age: #{state.age}, Favourite colour: "
        ),
        span(style: "color: #{state.favourite_colour}") { state.favourite_colour },
        span(")"),
      )
    )
  end

  def render
    return confirmation if state.complete

    errors = ul(state.errors.map { |e| li(e) }) unless state.errors.empty?
    section(
      form(onsubmit: callback(:process_form, take_form_values: true, prevent_default: true)) {
        [
          div(Class: "inputgroup") {
            [
              label(for: :name) { "Name" },
              input(value: state.name, name: :name),
            ]
          },
          div(Class: "inputgroup") {
            [
              label(for: :age) { "Age" },
              input(value: state.age.to_s, name: :age, type: :number),
            ]
          },
          div(Class: "inputgroup") {
            [
              label(for: :favourite_colour) { "Favourite colour" },
              input(value: state.favourite_colour, name: :favourite_colour, type: :color),
            ]
          },
          div(Class: "btngroup") {
            input(type: "submit", value: "Submit")
          },
          (errors ? div(h4("Errors:"), errors) : nil),
        ]
      }
    )
  end
end
