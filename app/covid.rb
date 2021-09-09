class UnitedKingdom < Country
  def what_do_i_need(occasion, person)
    case occasion.type
    when "going_to_work"
      # ...
    when "international_travel"
      colour_code = country_colours[occasion.departure_country]

      person.recently_visited_countries.each do |country|
        colour = country_colours[country]
        # ...
      end

      case colour_code
      when "AMBER"
        rules = generate_amber_rules(occasion, person)
      when "RED"
        rules = generate_red_rules(occasion, person)
      when "GREEN"
        rules = generate_green_rules(occasion, person)
        return nil
      else
        raise "invalid colour"
      end

      pre_arrival_test_status = occasion.departure_country.test_status

      case occasion.arrival_country
      when "England"
        raise "Fill in locator form" unless person.locator_form.complete

        if person.vaccination_status.complete && person.vaccination_status.uk_approved
          if person.test_to_release.opted_in
            # ...
          end
        end
      when "Scotland"
        # ...
      end
    end
  end
end
