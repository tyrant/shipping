module ApplicationHelper

  # The most recent five news pages.
  def recent_news

    # Grab the sub-pages of the 'news' page...
    news_page = Comfy::Cms::Page.where(label: 'news').first

    if news_page
      news_page.children.find_all do |page|
        page.is_published?

      # ...order them by either published or creation date, descending...
      end.sort do |page1, page2|                   
        page_published_on(page2).to_i <=> page_published_on(page1).to_i

      # ...grab the first five and return their label and creation date.
      end.take(5).map do |page|            
        {
          label: page.label,
          slug:  page.slug, 
          date:  page_published_on(page).strftime('%F')
        }
      end
    else 
      []
    end
  end

  # The most recent five media pages.
  def recent_media

    media_page = Comfy::Cms::Page.where(label: 'Media').first

    if media_page
      media_page.children.find_all do |page|
        page.is_published?

      end.sort do |page1, page2|
        page_published_on(page2).to_i <=> page_published_on(page1).to_i

      end.take(5).map do |page|
        {
          label: page.label,
          slug:  page.slug,
          date:  page_published_on(page).strftime('%F')
        }
      end
    else
      []
    end
  end

  # Given a news article, return (if it has one), its published_on block content, otherwise its created_at.
  def page_published_on(page)
    published_on = page.blocks.find {|b| b.identifier == 'published_on' }
    if !!published_on && !published_on.content.blank?
      DateTime.parse published_on.content
    else
      page.created_at
    end
  end

  # Filter the site files by whether they're categorised as 'ships', randomise their order, and return their URLs.
  def ship_images
    @cms_site.files.find_all do |file|
      file.categories.map {|c| c.label }.include? 'ships'
    end.shuffle!
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
    Comfy::Cms::Page.find_by_label('About the New Zealand Shipping Federation').children
  end

  # Is the current page (the Media page or one of its children), or not?
  def media_page?
    @cms_page.parent.present? and (@cms_page.slug == 'media' || @cms_page.parent.slug == 'media')
  end
end
