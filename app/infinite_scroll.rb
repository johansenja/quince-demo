class InfiniteScroll < Quince::Component
  PAGE_SIZE = 20
  TBODY_SELECTOR = "table_body".freeze

  State(
    coffees: Rbs("Array[MockCoffeeProvider::Coffee]"),
  )

  def initialize
    @state = State.new(
      coffees: load_coffees(0),
    )
  end

  private def load_coffees(current_offset)
    # mimicking an orm but actually just a class reading from jsonl file
    MockCoffeeProvider.all
                      .filter(offset: current_offset, limit: PAGE_SIZE)
                      .as_coffees
  end

  exposed def load_more
    state.coffees += load_coffees(state.coffees.length)
  end

  private def render_coffee_list
    state.coffees.map do |pr|
      tr(
        pr.values.map { |val| td(val.to_s) }
      )
    end
  end

  def render
    cb = callback :load_more,
                  if: "this.scrollTop >= this.scrollHeight - 750",
                  debounce_ms: 300,
                  rerender: {
                    mode: :append_diff,
                    method: :render_coffee_list,
                    selector: "##{TBODY_SELECTOR}",
                  }

    section(id: :infinite_scroll) {[
      h2("Top coffees of all time"),
      table(onscroll: cb) {[
        thead(
          tr(
            MockCoffeeProvider::Coffee.members.map { |attrib| th(attrib.to_s) }
          )
        ),
        tbody(id: TBODY_SELECTOR) {
          render_coffee_list
        }
      ]},
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
