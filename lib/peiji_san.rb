# Peiji-San uses named scopes to create a thin pagination layer.
#
# Example:
#
#   class Member < ActiveRecord::Base
#     extend PeijiSan
#     self.entries_per_page = 32
#   end
#
# Now you can start scoping your queries by `page':
#
#   Member.active.page(2)
#
# Which will return 32 records with an offset of 32, as that's the second page.
#
# See PeijiSan::PaginationMethods and PeijiSan::ViewHelper for more info.
module PeijiSan
  ENTRIES_PER_PAGE = 32
  
  module PaginationMethods
    attr_accessor :current_page, :entries_per_page, :scope_without_pagination
    
    # Returns whether or not the given page is the current page.
    def current_page?(page)
      @current_page == page
    end
    
    # Returns whether or not there is a next page for the current scope.
    def has_next_page?
      @current_page < page_count
    end
    
    # Returns whether or not there is a previous page for the current scope.
    def has_previous_page?
      @current_page != 1
    end
    
    # Returns the next page number if there is a next page, returns +nil+
    # otherwise.
    def next_page
      @current_page + 1 if has_next_page?
    end
    
    # Returns the previous page number if there is a previous page, returns
    # +nil+ otherwise.
    def previous_page
      @current_page - 1 if has_previous_page?
    end
    
    # Returns the row count for all the rows that would match the current
    # scope, so not only on the current page.
    def unpaged_count
      scope_without_pagination.count
    end
    
    # Returns the number of pages for the current scope.
    def page_count
      (unpaged_count.to_f / @entries_per_page).ceil
    end
  end
  
  # Sets the number of entries you want per page.
  #
  #   class Member < ActiveRecord::Base
  #     extend PeijiSan
  #     entries_per_page 32
  #   end
  def entries_per_page=(entries)
    @entries_per_page = entries
  end
  
  # Returns the number of entries you want per page.
  #
  #   class Member < ActiveRecord::Base
  #     extend PeijiSan
  #     entries_per_page 32
  #   end
  #   Member.entries_per_page #=> 32
  def entries_per_page
    @entries_per_page
  end
  
  # Set the current scope to a given page number.
  #
  # Consider:
  #
  #   class Member < ActiveRecord::Base
  #     extend PeijiSan
  #     entries_per_page 32
  #   end
  #
  # This adds <tt>{ :limit => 32, :offset => 0 }</tt> to the scope:
  #
  #   Member.page(1)
  #
  # This adds <tt>{ :limit => 32, :offset => 31 }</tt> to the scope:
  #
  #   Member.page(2)
  #
  # You can optionally override the entries_per_page setting by sepcifying a
  # second argument:
  #
  #   Member.page(2, 5) # Page 2, 5 entries
  def page(page, entries_per_page=nil)
    page = page.blank? ? 1 : page.to_i
    entries_per_page = entries_per_page || self.entries_per_page || ENTRIES_PER_PAGE
    
    entries = scoped
    entries.extend(PeijiSan::PaginationMethods)
    entries.current_page = page
    entries.entries_per_page = entries_per_page
    entries.scope_without_pagination = scoped
    
    entries.limit(entries_per_page).offset((page - 1) * entries_per_page)
  end
end