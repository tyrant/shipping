module ApplicationHelper

  # Given a news article, return (if it has one), its published_on block content, otherwise its created_at.
  def news_published_on(page)
    published_on = page.blocks.find {|b| b.identifier == 'published_on' }
    if !!published_on
      c = published_on.content
      y, m, d, h, i, s = c[0,4], c[5,2], c[8,2], c[11,2], c[14,2], c[17,2]
      Time.new(y, m, d, h, i, s)
    else
      page.created_at
    end
  end

  # Grab the headlines and dates of the five most recent news article pages.
  # This isn't the most computationally efficient, as it returns the entire news table.
  def recent_news
    news_pages = @cms_site.pages.find do |page|  # Grab the sub-pages of the 'news' page...
      page.label == 'news'

    end

    if news_pages
      news_pages.children.find_all do |page|
        page.is_published?

      end.sort do |page1, page2|                   # ...order them by either published or creation date, descending...
        news_published_on(page2).to_i <=> news_published_on(page1).to_i

      end.take(5).map do |page|            # ...grab the first five and return their label and creation date.

        {
          label: page.label,
          slug:  page.slug, 
          date:  news_published_on(page).strftime('%F')
        }
      end
    else 
      []
    end
  end

  # Filter the site files by whether they're categorised as 'ships', and return their URLs.
  def ship_images
    @cms_site.files.find_all do |file|
      file.categories.map {|c| c.label }.include? 'ships'
    end
  end

  def current_link_to(content, url, options={})
    options[:class] = if current_page? url
      'current-page'
    else
      ''
    end

    
    link_to content, url, options
  end

  def slugify(string)
    string.parameterize
  end

  def about_nzsf_subpages
    Comfy::Cms::Page.find_by_label('About the NZSF').children
  end
end
