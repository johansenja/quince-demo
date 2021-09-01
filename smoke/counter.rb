class Counter < Respond::Component
  State(count: Integer)

  self.initial_state = {
    count: 0,
  }

  exposed def reload_footer
    state.count += 1
  end

  def render
    section(
      button(onclick: method(:reload_footer)) { "Increment" },
      h3("Count: #{state.count}")
    )
  end
end
