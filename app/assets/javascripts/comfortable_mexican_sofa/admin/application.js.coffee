#= require comfortable_mexican_sofa/lib/redactor

  # Fire up the Redactor editor.
  if window.CMS
    window.CMS.wysiwyg = ->

      $.Redactor.prototype.scriptbuttons = ->
        {
          init: ->
            sup = @button.add 'superscript', 'x²'
            sub = @button.add 'subscript', 'x₂'
            @button.addCallback sup, @scriptbuttons.formatSup
            @button.addCallback sub, @scriptbuttons.formatSub
          formatSup: ->
            @inline.format 'sup'
          formatSub: ->
            @inline.format 'sub'
        }

      csrf_token = $('meta[name=csrf-token]').attr('content');
      csrf_param = $('meta[name=csrf-param]').attr('content');
      if (csrf_param != undefined && csrf_token != undefined)
        csrf_params = '&' + csrf_param + "=" + encodeURIComponent(csrf_token)
      else
        csrf_params = ''

      $('textarea[data-cms-rich-text]').redactor
        height: 1000
        buttons: ['format', 'bold', 'italic', 'underline', 'lists', 'image', 'link']
        plugins: ['scriptbuttons']
        imageUpload: CMS.file_upload_path + '?ajax=1' + csrf_params
        imageGetJson: CMS.file_upload_path + '?ajax=1' + csrf_params
        formattingTags: ['p', 'h1', 'h2', 'h3', 'h4']
        callbacks: 
          init: ->
            console.log 'init'
            $('.redactor-box').on 'drop', (e) ->
              console.log(e)
              src = e.originalEvent.dataTransfer.getData 'text/plain'
              img = new Image()
              img.src = src
              console.log(img)

              $(this).trigger('drop', img)

            # $('.redactor-box').bind('dropthis', (e) ->
            #   console.log 'drop triggered'
            # ).droppable
            #   drop: function(e, ui) ->

