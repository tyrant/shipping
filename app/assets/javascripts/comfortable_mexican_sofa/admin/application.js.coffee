#= require comfortable_mexican_sofa/lib/redactor

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
        #imageUpload: $('.cms-files-modal').data('iframe-src') + '?ajax=1'
        #imageGetJson: $('.cms-files-modal').data('iframe-src') + '?ajax=1'
        formattingTags: ['p', 'h1', 'h2', 'h3', 'h4']