module SortHelper
  def sortable(column_name, db_column_name, title = nil)
    title ||= column_name.titleize
    css_class = (db_column_name == sort_column) ? "current #{sort_direction}" : nil
    direction = (db_column_name == sort_column && sort_direction == 'desc') ? "asc" : "desc"
    link_to title, { sort: db_column_name, direction: direction }, { class: css_class }
  end
end
