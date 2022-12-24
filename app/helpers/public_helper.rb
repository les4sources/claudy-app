module PublicHelper
  def button_label_with_count(label, count, options = {})
    out = ActiveSupport::SafeBuffer.new
    out << label
    out << content_tag(:span, count, class: "count #{"count--zero" if count == 0} #{"count--tab" if options[:tab]}")
  end

  def button_label_with_icon(label, icon, options = {})
    out = ActiveSupport::SafeBuffer.new
    if options[:right]
      out << label
      out << content_tag(:svg, render("layouts/icons/paths/#{icon}"), class: "ml-2 -mr-1 w-5 h-5 #{options[:icon_class]}", stroke: "currentColor", "stroke-width": "1.5", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg", "aria-hidden": "true")
    else
      out << content_tag(:svg, render("layouts/icons/paths/#{icon}"), class: "mr-2 -ml-1 w-5 h-5 #{options[:icon_class]}", stroke: "currentColor", "stroke-width": "1.5", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg", "aria-hidden": "true")
      out << label
    end
    out
  end

  def info_header(label, **opts)
    content_tag(:div, class: "info__header grid-x grid-padding-x") do
      content_tag(:div, class: "cell small-12") do
        content_tag(:h4, label, **opts)
      end
    end
  end

  def info_line(label, **opts, &block)
    title_class = if opts[:title_class].present?
                    opts[:title_class]
                  else
                    ''
                  end
    value_class = if opts[:value_class].present?
                    opts[:value_class]
                  else
                    ''
                  end
    out = ActiveSupport::SafeBuffer.new
    out << content_tag(:div, class: "info__line grid-x grid-padding-x") do
      out_cells = ActiveSupport::SafeBuffer.new
      out_cells << content_tag(:div, class: "cell small-12") do
        content_tag(:strong, label, class: "info__line__label #{title_class}")
      end
      out_cells << content_tag(:div, class: "cell small-12 #{value_class}") do
        yield block
      end
      out_cells
    end
    out << content_tag(:div, nil, class: "spacer-1")
    out
  end

  def legend_item(color: nil, label: nil)
    content_tag(:div, class: "legend__item") do
      content_tag(:div, class: "grid-x align-middle") do
        out = ActiveSupport::SafeBuffer.new
        out << content_tag(:div, class: "cell shrink") do
          content_tag(:div, nil, class: "legend__item__color", style: "background-color: #{color}")
        end
        out << content_tag(:div, class: "cell auto") do
          content_tag(:div, label, class: "legend__item__label")
        end
        out
      end
    end
  end

  def section_heading_tw(heading:, extra: nil, spacing: :hr, count: nil, icon: nil, span_id:nil)
    out = ActiveSupport::SafeBuffer.new
    out << content_tag(:div, class: "mb-2 md:mb-4 pb-4") do
      out2 = ActiveSupport::SafeBuffer.new
      out2 << content_tag(:h3, heading, class: "text-lg font-medium leading-6 text-gray-900")
      if extra
        out2 << content_tag(p, extra, class: "mt-1 text-sm text-gray-500")
      end
      out2
    end
    out.html_safe
  end
end
