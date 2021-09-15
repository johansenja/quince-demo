class ShowHide < Quince::Component
  def render
    section(
      ToggleVisibilitySection(),
    )
  end
end

class ToggleVisibilitySection < Quince::Component
  State(
    para_visible: Rbs("TrueClass | FalseClass"),
  )

  def initialize
    @state = State.new(
      para_visible: false,
    )
  end

  exposed def toggle_para_visible
    state.para_visible = !state.para_visible
  end

  def render
    div(
      state.para_visible ? para("This is the secret message") : nil,
      button(onclick: method(:toggle_para_visible), Class: "btn-lg", id: "show-hide") {
        "#{state.para_visible ? "Hide" : "Show"} secret message"
      }
    )
  end
end