require "./respond-sinatra/lib/respond_sinatra"

class App < Respond::Component
  private def render_buyer(id, bh)
    fav = img(src: bh["favicon"]) if bh["favicon"]
    images = bh["images"]&.map do |im|
      width, height = im["size"]

      img(
        src: im["src"],
        height: height || Undefined,
        width: width || Undefined,
        alt: "#{bh["title"]} - #{im["src"]}",
      )
    end

    div(
      div(
        h3(style: "display: flex; align-items: center; justify-content: space-around") {
          [
            span(fav),
            span(bh["title"]),
            span(" (Stotles ID: #{id})"),
          ]
        },
        para(bh["description"]),
        para(a(href: bh["url"]) { bh["url"] }),
        div(
          images
        )
      ),
      hr
    )
  end

  def render
    most_popular = JSON.parse(File.read("./stotles/buyers_most_popular.json")).map do |id, b|
      render_buyer(id, b)
    end
    least_popular = JSON.parse(File.read("./stotles/buyers_least_popular.json")).map do |id, b|
      render_buyer(id, b)
    end

    html(
      head(
        title("Buyer metadata inspection")
      ),
      body {
        [
          h1("Buyer metadata data mining"),
          h2("Most popular UK buyers (by number of records published) over the last quarter"),
          most_popular,
          h3("Least popular UK buyers (by number of records published) over the last quarter"),
          least_popular,
        ]
      }
    )
  end
end

expose App, at: "/"
