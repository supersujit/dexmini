# frozen_string_literal: true

# mixin for providing the pagination
module Pagination
  extend ActiveSupport::Concern

  included do
    helper_method :paginate_records
  end

  def paginate_records(query, per_page: 10)
    @page = params.fetch(:page, 1).to_i
    @per_page = per_page

    @records = query.limit(@per_page).offset((@page - 1) * @per_page)
    @total_count = query.count
    @total_pages = (@total_count.to_f / @per_page).ceil
  end
end
