# -*- encoding : utf-8 -*-
module PeijiSan
  # Optionally defines the peiji_san_options method in your helper to override
  # the default options.
  #
  # Include the PeijiSan::ViewHelper into one of your view helpers to acquire
  # PeijiSan superpowers in your view.
  #
  #   class ApplicationHelper
  #     include PeijiSan::ViewHelper
  #   end
  #
  #   @collection = Member.active.page(2)
  #
  #   <% pages_to_link_to(@collection).each do |page %>
  #     <%= page.is_a?(String) ? page : link_to_page(page, @collection) %>
  #   <% end %>
  module ViewHelper
    # The default options for link_to_page and pages_to_link_to.
    DEFAULT_PEIJI_SAN_OPTIONS = {
      # For link_to_page
      :page_parameter => :page,
      :anchor => nil,
      :current_class => :current,
      # For pages_to_link_to
      :max_visible => 11,
      :separator => '…'
    }
    
    # Override this method in your helper to override default values:
    #
    #   def peiji_san_options
    #     { :max_visible => 7 }
    #   end
    def peiji_san_options
    end
    
    # Creates a link using +link_to+ for a page in a pagination collection. If
    # the specified page is the current page then its class will be `current'.
    #
    # Options:
    #   [:page_parameter]
    #     The name of the GET parameter used to indicate the page to display.
    #     Defaults to <tt>:page</tt>.
    #   [:current_class]
    #     The CSS class name used when a page is the current page in a pagination
    #     collection. Defaults to <tt>:current</tt>.
    def link_to_page(page, paginated_set, options = {}, html_options = {})
      page_parameter = peiji_san_option(:page_parameter, options)
      
      # Sinatra/Rails differentiator
      pageable_params = respond_to?(:controller) ? controller.params : self.params
      
      url_options = (page == 1 ? pageable_params.except(page_parameter) : pageable_params.merge(page_parameter => page))
      anchor = peiji_san_option(:anchor, options)
      url_options[:anchor] = anchor if anchor
      html_options[:class] = peiji_san_option(:current_class, options) if paginated_set.current_page?(page)
      
      # Again a little fork here
      normalized_url_options = if respond_to?(:controller) # Rails
        url_for(url_options)
      else # Sinatra
        root_path = env['SCRIPT_NAME'].blank? ? "/" : env["SCRIPT_NAME"]
        url_for(root_path, url_options)
      end
      
      link_to page, normalized_url_options, html_options
    end
    
    # This Rails method is overridden to provide compatibility with other frameworks. By default it will just call super
    # if super is provided. However, you will need your application to provide a standard url_for method
    # in the context where this helper is used. For that you could use https://github.com/emk/sinatra-url-for/
    def link_to(*arguments)
      return super if defined?(super)
      
      # What follows is a very simplistic implementation of link_to
      link_text, url, html_options = arguments[0..2]
      html_options[:href] = url
      attr_string = html_options.map do | attribute, value |
        '%s="%s"' %  [Rack::Utils.escape_html(attribute), Rack::Utils.escape_html(value)]
      end.join(' ')
      
      # Compose the tag
      return "<a %s>%s</a>" % [attr_string, Rack::Utils::escape_html(link_text)]
    end
    
    # Returns an array of pages to link to. This array includes the separator, so
    # make sure to keep this in mind when iterating over the array and creating
    # links.
    #
    # For consistency’s sake, it is adviced to use an odd number for
    # <tt>:max_visible</tt>.
    #
    # Options:
    #   [:max_visible]
    #     The maximum amount of elements in the array, this includes the
    #     separator(s). Defaults to 11.
    #   [:separator]
    #     The separator string used to indicate a range between the first or last
    #     page and the ones surrounding the current page.
    #
    #   collection = Model.all.page(40)
    #   collection.page_count # => 80
    #
    #   pages_to_link_to(collection) # => [1, '…', 37, 38, 39, 40, 41, 42, 43, '…', 80]
    def pages_to_link_to(paginated_set, options = {})
      current, last = paginated_set.current_page, paginated_set.page_count
      max = peiji_san_option(:max_visible, options)
      separator = peiji_san_option(:separator, options)
      
      if last <= max
        (1..last).to_a
      elsif current <= ((max / 2) + 1)
        (1..(max - 2)).to_a + [separator, last]
      elsif current >= (last - (max / 2))
        [1, separator, *((last - (max - 3))..last)]
      else
        offset = (max - 4) / 2
        [1, separator] + ((current - offset)..(current + offset)).to_a + [separator, last]
      end
    end
    
    private
    
    def peiji_san_option(key, options)
      if value = options[key]
        value
      elsif (user_options = peiji_san_options) && user_options[key]
        user_options[key]
      else
        DEFAULT_PEIJI_SAN_OPTIONS[key]
      end
    end
  end
end
