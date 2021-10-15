require "svggraph"

class ChartExample < Quince::Component
  ARRAY_OF_10_INT = Rbs("[Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer]").freeze
  ARRAY_OF_ARRAY_OF_10_INT = Rbs("Array[#{ARRAY_OF_10_INT}]").freeze
  BAR_LABELS_TYPE = Rbs("[String, String, String, String, String, String, String, String, String, String]").freeze
  CHART_TYPE_OPTIONS = {
    bar: "Bar chart",
    line: "Line graph"
  }
  CHART_TYPE = Rbs("#{CHART_TYPE_OPTIONS.keys.map { |k| k.inspect }.join(" | ")}").freeze
  T = Quince::Types

  State(
    title: T::OptionalString,
    x_title: T::OptionalString,
    y_title: T::OptionalString,
    series: ARRAY_OF_ARRAY_OF_10_INT,
    bar_labels: BAR_LABELS_TYPE,
    chart_type: CHART_TYPE,
  )

  def initialize
    @state = State.new(
      title: "Top 10 numbers of all time",
      x_title: "Numbers",
      y_title: "Popularity",
      series: [
        [3, 6, 7, 8, 4, 5, 8, 10, 5, 2],
      ],
      bar_labels: %w[0 1 2 3 4 5 6 7 8 9],
      chart_type: :bar,
    )
  end

  exposed def set_form_values
    state.title = default_if_empty(params[:title], nil)
    state.x_title = default_if_empty(params[:x_title], nil)
    state.y_title = default_if_empty(params[:y_title], nil)

    series = 0
    index = 0

    new_series = []
    current = []

    until (val = params["series_#{series}_#{index}"]).nil?
      current.push(val.to_i)
      if index == 9
        new_series.push(current)
        current = []
        series += 1
        index = 0
      else
        index += 1
      end
    end

    labels = []
    0.upto(9) do |label_number|
      labels << default_if_empty(params["bar_labels_#{label_number}"], label_number.to_s)
    end
    state.bar_labels = labels
    state.chart_type = params[:chart_type].to_sym

    state.series = new_series
  end

  exposed def add_series
    state.series += [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
  end

  private def default_if_empty(value, default)
    value.respond_to?(:empty?) && value.empty? ? default : value
  end

  CHART_OPTIONS = {
    width: 640,
    height: 300,
    show_graph_title: true,
    show_x_title: true,
    show_y_title: true,
    y_title_location: :end,
    no_css: true,
  }.freeze
  private_constant :CHART_OPTIONS

  CHART_CONTAINER_ID = "chart".freeze

  private_constant :CHART_CONTAINER_ID

  private def render_chart
    chart_type = state.chart_type == :bar ? SVG::Graph::Bar : SVG::Graph::Line
    graph = chart_type.new(
      CHART_OPTIONS.merge(
        graph_title: state.title || "chart title",
        x_title: state.x_title || "x axis title",
        y_title: state.y_title || "y axis title",
        fields: state.bar_labels,
      )
    )

    state.series.each_with_index do |s, i|
      graph.add_data(
        data: s,
        title: "Document #{i}"
      )
    end

    div(id: CHART_CONTAINER_ID) {
      graph.burn_svg_only
    }
  end

  def render
    section(
      render_chart,
      hr(id: "chart-example-divider"),
      Form(
        title: state.title,
        x_title: state.x_title,
        y_title: state.y_title,
        set_form_values: callback(
          :set_form_values,
          take_form_values: true,
          prevent_default: true,
        ),
        series: state.series,
        add_series: callback(:add_series),
        bar_labels: state.bar_labels,
        chart_type: state.chart_type,
      ),
    )
  end

  class Form < Quince::Component
    class Series < Quince::Component
      Props(
        series: ChartExample::ARRAY_OF_10_INT,
        index: Integer,
        bar_labels: ChartExample::BAR_LABELS_TYPE,
      )

      def render
        series_name = "series_#{props.index}"
        fieldset {[
          h3("Data series: Document #{props.index}"),
          props.series.map.with_index { |s, i|
            name = "#{series_name}_#{i}"

            span(
              input(placeholder: props.bar_labels[i], name: name, id: name, value: s.to_s)
            )
          }
        ]}
      end
    end

    T = Quince::Types

    Props(
      title: T::OptionalString,
      x_title: T::OptionalString,
      y_title: T::OptionalString,
      set_form_values: Quince::Callback::Interface,
      series: ChartExample::ARRAY_OF_ARRAY_OF_10_INT,
      add_series: Quince::Callback::Interface,
      bar_labels: ChartExample::BAR_LABELS_TYPE,
      chart_type: ChartExample::CHART_TYPE,
    )

    def render
      div(id: "chart-form") {[
        form {[
          div(id: "chart-form-header") {[
            h1("Customise chart:"),
            button(id: "chart-refresh", Class: "btn-lg", onclick: props.set_form_values) { "Update 🔃" },
          ]},
          fieldset(Class: "chart-labels-fieldset") {[
            h3("General"),
            label(for: "chart_type") { "Chart type" },
            select(id: "chart_type", name: "chart_type") {
              ChartExample::CHART_TYPE_OPTIONS.map { |t, label|
                option(value: t, selected: t == props.chart_type) { label }
              }
            },
            label(for: "title") { "Chart title" },
            input(name: "title", id: "title", value: props.title),
            label(for: "x_title") { "x axis title" },
            input(name: "x_title", id: "x_title", value: props.x_title),
            label(for: "y_title") { "y axis title" },
            input(name: "y_title", id: "y_title", value: props.y_title),
          ]},
          fieldset {[
            h3("Bar labels"),
            *props.bar_labels.map.with_index { |f, i|
              name = "bar_labels_#{i}"
              input(
                name: name,
                value: f.to_s,
                id: name,
                placeholder: "Bar #{i}",
              )
            },
          ]},
          *props.series.map.with_index { |s, i|
            Series(series: s, index: i, update_series: props.set_form_values, bar_labels: props.bar_labels)
          },
        ]},
        props.series.length <= 5 ? (button(onclick: props.add_series) { "Add another document +" }) : nil
      ]}
    end
  end
end
