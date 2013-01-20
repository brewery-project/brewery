module Brewery
  module ApplicationHelper
    def css_loading_icon
      return '<div class="bubblingG">
          <span id="bubblingG_1"></span>
          <span id="bubblingG_2"></span>
          <span id="bubblingG_3"></span>
        </div>'.html_safe
    end

    def display_value(value)
      if value.blank?
        return I18n.t('brewery.general.not_provided_html').html_safe
      else
        return value
      end
    end
  end
end
