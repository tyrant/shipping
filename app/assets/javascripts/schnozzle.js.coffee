# A few utility functions.

_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g # Replace <% %> with {{ }}
  execute: /\{\[(.+?)\]\}/g     # Replace <%= %> with {[ ]}

$ ->

  # Page scroll: whenever the user scrolls the page up and down, if they've scrolled
  # past 111px, set the nav bar position css to 'fixed', and set the body position-top
  # to 70px; otherwise, set its css to 'static' and body position-top to 0px.
  fixHeader = ->

    fixed = false # Without an external boolean to check, we'd be setting the values below every time.

    $(window).on 'scroll', (e) ->

      logoHeight = $('.header-content').height()
      navHeight = $('nav.header').height()
      navMargin = parseInt($('nav.header').css('margin-bottom'))

      if $(window).scrollTop() >= logoHeight and !fixed
        $('nav.header').removeClass('navbar-static-top').addClass('navbar-fixed-top')
        #$('#recent_news').css('position', 'fixed')
        $('body').css 'padding-top', (logoHeight + navHeight + navMargin) + 'px'
        $('.header-content').hide()
        fixed = true

      else if $(window).scrollTop() < logoHeight and fixed
        $('nav.header').removeClass('navbar-fixed-top').addClass('navbar-static-top')
        #$('#recent_news').css('position', 'static')
        $('body').css 'padding-top', '0px'
        $('.header-content').show()
        fixed = false

    $(window).scroll() # Fire the above function on page load, once, before the user manually scrolls.


  carousel = ->
    # $('#carousel_images').carousel
    #   interval: false


  close = ->
    $('.flash button.close').on 'click', ->
      $('.flash').remove()


  # CSS fixer - every 100 milliseconds, check if the Google search box has loaded. If so, increase
  # its height to 26px, and a few other tweaks, and halt.
  search = ->
    blah = setInterval ->
      searchBox = $('#gsc-iw-id1')
      if searchBox.length
        searchBox.css
          position: 'relative'
          height: '30px'
          top: '-1px'
          left: '10px'
        $('.gsc-search-button').css
          height: '14px'
          width: '14px'

        clearInterval blah
    , 100

  # Load a batch of news articles.
  loadMore = ->

    news_tmpl = $('#news_tmpl').text()
    earliestTimestamp = 2**32

    $('#load_more').on 'click', ->
      $('#load_more #spinner').show()

      $.get "/more_news?before=#{earliestTimestamp}", (response) ->
        $('#load_more #spinner').hide()

        # Add the latest items to the page
        for page in response
          page_html = _.template(news_tmpl)(page)
          $('#news').append page_html

          earliestTimestamp = page.timestamp if page.timestamp < earliestTimestamp

    $('#load_more').click()

    

  fixHeader()
  carousel()
  close()
  search()
  loadMore()