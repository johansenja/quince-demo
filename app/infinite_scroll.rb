class InfiniteScroll < Quince::Component
  PAGE_SIZE = 20

  State(
    next_offset: Integer,
    coffees: Rbs("Array[MockCoffeeProvider::Coffee]"),
    end_of_list_reached: Rbs("true | false"),
  )

  def initialize
    @state = State.new(
      next_offset: PAGE_SIZE,
      coffees: load_coffees(0),
      end_of_list_reached: false,
    )
  end

  private def load_coffees(current_offset)
    # mock provider actually just loading in from jsonl file
    coffees = MockCoffeeProvider.all
                                .filter(offset: current_offset, limit: PAGE_SIZE)
                                .as_coffees
    state.end_of_list_reached = true if coffees.empty?
    coffees
  end

  exposed def load_more
    p state.next_offset
    state.coffees += load_coffees(state.next_offset)
    state.next_offset += PAGE_SIZE
  end

  def render
    body_rows = state.coffees.map do |pr|
      tr(
        pr.values.map { |val| td(val.to_s) }
      )
    end

    end_msg = if state.end_of_list_reached
                para("Nothing else to show! (it's not ", span(i("actually")), " infinite 😈)")
              else
                nil
              end
    cb = if state.end_of_list_reached
           Undefined
         else
           callback :load_more,
                    if: "this.scrollTop >= this.scrollHeight - 500",
                    debounce_ms: 300
         end

    section(id: :infinite_scroll) {[
      h2("Top coffees of all time"),
      table(onscroll: cb) {[
        thead(
          tr(
            MockCoffeeProvider::Coffee.members.map { |attrib| th(attrib.to_s) }
          )
        ),
        tbody {
          body_rows
        }
      ]},
      end_msg
    ]}
  end
end

class MockCoffeeProvider
  Coffee = Struct.new :ID, :"Blend Name", :Origin, :Notes

  class << self
    # thank you to faker for the excellent data
    PRODUCT_FIXTURE_PATH = File.join(__dir__, "..", "fixtures", "coffees.jsonl")

    def all
      @coffees = File.read(PRODUCT_FIXTURE_PATH)
                     .lines
                     .map { |l| JSON.parse(l, symbolize_names: true) }
      self
    end

    def filter(offset:, limit:)
      @coffees = @coffees.slice! offset, limit
      self
    end

    def as_coffees
      @coffees.map! { |pr| Coffee.new pr[:ID], pr[:"Blend Name"], pr[:Origin], pr[:Notes] }
    end
  end
end
