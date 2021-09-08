class Counter < Respond::Component
  State(val: Integer)

  self.initial_state = {
    val: 0,
  }

  exposed def increment
    state.val += 1
  end

  exposed def decrement
    state.val -= 1
  end

  def render
    section(
      div(id: :count_container) {
        [
          button(onclick: method(:increment), id: :increment, Class: "btn-lg") { "++" },
          h3("Count: #{state.val}"),
          button(onclick: method(:decrement), id: :decrement, Class: "btn-lg") { "--" },
        ]
      }
    )
  end
end
