# -*- encoding : utf-8 -*-
module ApplicationHelper
  def make_breadcrumb
    url_for.split('/').map do |part|
      # Skip IDs, we use the instance variable to go easier on the database.
      next if part.to_i > 0 || part.blank?

      obj = instance_variable_get("@#{part.singularize}")
      # Don't link action's names ("edit").
      next if obj.blank? && !current_page?(action: :index)

      index_url = url_for(controller: part, action: :index)
      index_name = part.humanize.pluralize.titleize
      out = bc_part(index_name, index_url)

      if obj
        if obj.id
          obj_url = url_for(controller: part, action: :show, id: obj.id)
          out << bc_part(obj.name, obj_url)
        else
          out << bc_part(obj.name.presence || 'New', nil)
        end
      end
      out
    end.compact.join.html_safe
  end

  def bc_part(name, url)
    content_tag(:li, link_to_unless(current_page?(url), name, url))
  end
end
