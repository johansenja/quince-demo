class Autocomplete < Quince::Component
  State(
    val: String,
    selected: Rbs("Symbol | nil")
  )

  def initialize
    @state = State.new(
      val: "",
      selected: nil,
    )
  end

  COMPLETED_CLASS = Set
  OBJECT_METHODS = Object.methods.to_set
  INPUT_WIDTH = "250px".freeze
  LIST_ID = "#{COMPLETED_CLASS.name.downcase}_methods".freeze

  private def render_options
    datalist(style: "width: #{INPUT_WIDTH}", id: LIST_ID) {
      (COMPLETED_CLASS.instance_methods - OBJECT_METHODS.to_a).sort.map do |v|
        option(value: v.to_s) { v.to_s }
      end
    }
  end

  exposed def set_val
    val = params[:params][:val]
    state.val = val
    if val.empty?
      state.selected = nil
    elsif COMPLETED_CLASS.method_defined? val
      state.selected = val.to_sym
    end
  end

  private def render_info
    return unless state.selected

    method = COMPLETED_CLASS.instance_method(state.selected)
    source = begin
               code = method.comment + method.source
               div(id: :selected_code_wrapper) {
                 pre(
                   CodePanel(code: code)
                 )
               }
             rescue MethodSource::SourceNotFoundError
               para "No source information available"
             end

    div(
      h3(
        span(
          code("#{COMPLETED_CLASS}##{method.name}")
        )
      ),
      hr,
      source
    )
  end

  def render
    section(id: :autocomplete) {[
      h2(span(code(COMPLETED_CLASS.name)), " methods in Ruby:"),
      form(action: "javascript:void") {[
        input(
          value: state.val,
          onblur: callback(:set_val, take_form_values: true),
          placeholder: "Start searching...",
          list: LIST_ID,
          name: :val,
          id: :val,
          style: "width: #{INPUT_WIDTH}",
          type: "search",
        ),
        render_options,
      ]},
      render_info
    ]}
  end
end
