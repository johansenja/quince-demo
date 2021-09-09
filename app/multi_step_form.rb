class MultiStepForm < Quince::Component
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
    buttons = div(Class: "btngroup") {
      [
        button(
          formaction: to(:prev_step),
          disabled: state.current_step.zero?,
          type: "submit",
        ) { "Previous" },
        button(
          formaction: to(:next_step),
          disabled: state.current_step === 4,
          type: "submit",
        ) { "Next" },
        button(
          formaction: to(:process_form),
          disabled: state.current_step < 4,
          type: "submit",
        ) { "Submit" },
      ]
    }

    contents = case state.current_step
      when 0
        [
          div(Class: "inputgroup") {
            [
              label(for: :first_name) { "First name" },
              input(value: state.step0[:first_name], name: :first_name),
            ]
          },
          div(Class: "inputgroup") {
            [
              label(for: :last_name) { "Last name" },
              input(value: state.step0[:last_name], name: :last_name),
            ]
          },
          div(Class: "inputgroup") {
            [
              label(for: :favourite_food) { "Favourite food" },
              input(value: state.step0[:favourite_food], name: :favourite_food),
            ]
          },
        ]
      when 1
        div(Class: "inputgroup") {
          [
            label(for: :favourite_car) { "Favourite car" },
            input(value: state.step1[:favourite_car], name: :favourite_car),
          ]
        }
      when 2
        div(Class: "inputgroup") {
          [
            label(for: :spaghetti) { "Spaghetti" },
            input(value: state.step1[:spaghetti], name: :spaghetti),
          ]
        }
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

    section(
      form(Method: :post) {
        [
          contents,
          *buttons,
        ]
      }
    )
  end
end
