class Counter < Respond::Component
  State(kount: Integer)

  self.initial_state = {
    kount: 0,
  }

  exposed def increment
    state.kount += 1
  end

  exposed def decrement
    state.kount -= 1
  end

  def render
    section(
      div(id: :count_container) {
        [
          button(onclick: method(:increment), id: :increment, Class: "btn-lg") { "++" },
          h3("Count: #{state.kount}"),
          button(onclick: method(:decrement), id: :decrement, Class: "btn-lg") { "--" },
        ]
      }
    )
  end
end
