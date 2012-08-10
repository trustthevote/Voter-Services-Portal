module FormHelper

  # Checks if we are collecting a certain field for a given form.
  def collecting?(form, field, app_config = AppConfig)
    !!app_config[form.to_s]["collect_#{field}"]
  end

  # Returns the select tags for the date entry and binds them
  def bound_date(f, field, options = {}, html_options = {})
    dts = ActionView::Helpers::DateTimeSelector.new(Date.today)

    start_year  = options[:start_year] || Date.today.year - 150
    end_year    = options[:end_year] || Date.today.year - 17
    object_name = options[:object_name] || 'registration'

    value   = f.object.send(field)
    month   = value && value.month
    day     = value && value.day
    year    = value && value.year

    months  = options_for_select([ nil ] + 12.times.map { |i| [ dts.send(:month_name, i + 1), i + 1 ] }, month)
    days    = options_for_select([ nil ] + (1 .. 31).to_a, day)
    years   = options_for_select([ nil ] + (start_year .. end_year).to_a.reverse, year)
    jsfield = field.to_s.camelcase(:lower)

    [ select_tag("#{object_name}[#{field}(3i)]", days,   html_options.merge('data-bind' => "instantValidation: { accessor: '#{jsfield}Day', attribute: '#{jsfield}', complex: true }")),
      select_tag("#{object_name}[#{field}(2i)]", months, html_options.merge('data-bind' => "instantValidation: { accessor: '#{jsfield}Month', attribute: '#{jsfield}', complex: true }")),
      select_tag("#{object_name}[#{field}(1i)]", years,  html_options.merge('data-bind' => "instantValidation: { accessor: '#{jsfield}Year', attribute: '#{jsfield}', complex: true }"))
    ].join(' ').html_safe
  end

  def bound_time(f, field, options = {}, html_options = {})
    object_name = options[:object_name] || 'registration'

    value   = f.object.send(field)
    year    = Date.today.year
    month   = Date.today.month
    day     = Date.today.day
    hour    = value && value.hour
    minute  = value && value.min

    hours   = options_for_select([ nil ] + (0 .. 23).to_a, hour)
    minutes = options_for_select([ nil ] + (0 .. 11).map { |n| [ "#{n * 5}".rjust(2, '0'), n * 5 ] }, minute)
    jsfield = field.to_s.camelcase(:lower)

    [ hidden_field_tag("#{object_name}[#{field}(1i)]", year),
      hidden_field_tag("#{object_name}[#{field}(2i)]", month),
      hidden_field_tag("#{object_name}[#{field}(3i)]", day),
      select_tag("#{object_name}[#{field}(4i)]", hours, html_options.merge('data-bind' => "value: #{jsfield}Hour", class: 'span1' )),
      ":",
      select_tag("#{object_name}[#{field}(5i)]", minutes, html_options.merge('data-bind' => "value: #{jsfield}Minute", class: 'span1' ))
    ].join(' ').html_safe
  end

  # Adds the custom suffix used by the record to the list of standard ones
  def name_suffixes_for(reg)
    suffixes = Dictionaries::NAME_SUFFIXES

    if !reg.suffix.blank? && !suffixes.include?(reg.suffix)
      suffixes = suffixes + [ reg.suffix ]
    end

    suffixes.sort
  end

  def changing_status_to_domestic_absentee?(reg = @registration)
    reg.currently_overseas? || !reg.currently_absentee?
  end

  def field_line(span, value, label = '&nbsp;', options = {})
    if value == :empty || (options.has_key?(:if) && !options[:if])
      label = value = "&nbsp;".html_safe
    end

    content_tag(:div, [
      content_tag(:div, value, class: 'value'),
      content_tag(:label, label )
    ].join(' ').html_safe, class: "span#{span} line")
  end

  def empty_span(span)
    content_tag(:div, "&nbsp;".html_safe, class: "span#{span}")
  end

  def ac
    AppConfig['autocomplete'] ? 'on' : 'off'
  end

  def office_address(locality)
    address = Office.where(locality: locality).first.try(:address)
    address && address.gsub("\n", "<br/>").html_safe
  end
end
