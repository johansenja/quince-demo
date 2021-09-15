class Counter < Quince::Component
  State(val: Integer)

  def initialize
    @state = State.new(
      val: 0,
    )
  end

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
          button(onclick: callback(:increment), id: :increment, Class: "btn-lg") { "++" },
          h3("Count: #{state.val}"),
          button(onclick: callback(:decrement), id: :decrement, Class: "btn-lg") { "--" },
        ]
      }
    )
  end
end
