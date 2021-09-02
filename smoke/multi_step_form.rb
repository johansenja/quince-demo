class MultiStepForm < Respond::Component
  State(
    step0: Rbs("Hash[:first_name | :last_name | :favourite_food, String]"),
    step1: Rbs("Hash[:favourite_car, String]"),
    step2: Rbs("Hash[:spaghetti, String]"),
    current_step: Integer,
  )

  self.initial_state = {
    step0: {
      first_name: "",
      last_name: "",
      favourite_food: "",
    },
    step1: {
      favourite_car: "",
    },
    step2: {
      spaghetti: "",
    },
    current_step: 0,
  }

  exposed def process_form
  end

  exposed def next_step
    state.current_step += 1
  end

  exposed def prev_step
    state.current_step -= 1
  end

  exposed def reset
    state.current_step = 0
  end

  def render
    buttons = [
      button(onclick: method(:prev_step), disabled: state.current_step.zero?) { "Previous" },
      button(onclick: method(:next_step), disabled: state.current_step === 4) { "Next" },
      button(onclick: method(:process_form), disabled: state.current_step < 4) { "Submit" },
    ]

    contents = case state.current_step
      when 0
        [
          input(value: state.step0[:first_name]),
          input(value: state.step0[:last_name]),
          input(value: state.step0[:favourite_food]),
        ]
      when 1
        input(value: state.step1[:favourite_car])
      when 2
        input(value: state.step1[:spaghetti])
      when 3
        [
          dl(
            dd("First name"),
            dt(state.step0[:first_name]),
            dd("Last name"),
            dt(state.step0[:last_name]),
            dd("Favourite food"),
            dt(state.step0[:favourite_food]),
            dd("Favourite car"),
            dt(state.step1[:favourite_car]),
            dd("spaghetti"),
            dt(state.step2[:spaghetti]),
          ),
        ]
      when 4
        return div(
                 para("Thanks for submitting!"),
                 button(onclick: method(:reset)) { "Reset" },
               )
      end

    div(form(onsubmit: method(:process_form)) { contents }, *buttons)
  end
end
