module ApplicationHelper
  def domains_link
    if current_user.superadmin?
      link_to('Domains', domains_url)
    else
      ''
    end
  end

  def domain_link(domain)
    if current_user.superadmin? || current_user.admin?(domain)
      "&rArr;&nbsp;#{link_to(domain.name, domain)}".html_safe
    else
      ''
    end
  end
end
