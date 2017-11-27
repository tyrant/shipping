# Custom JS for the admin area

#= require comfy/admin/cms/inlinestyle
#= require comfy/admin/cms/fontcolor

window.CMS.wysiwyg = ->
  csrf_token = $('meta[name=csrf-token]').attr('content')
  csrf_param = $('meta[name=csrf-param]').attr('content')

  if (csrf_param != undefined && csrf_token != undefined)
    params = csrf_param + "=" + encodeURIComponent(csrf_token)

  $('textarea.rich-text-editor, textarea[data-cms-rich-text]').redactor
    autoresize:       true
    imageUpload:      "#{CMS.file_upload_path}?source=redactor&type=image&#{params}"
    imageManagerJson: "#{CMS.file_upload_path}?source=redactor&type=image"
    fileUpload:       "#{CMS.file_upload_path}?source=redactor&type=file&#{params}"
    fileManagerJson:  "#{CMS.file_upload_path}?source=redactor&type=file"
    #definedLinks:     "#{CMS.pages_path}?source=redactor"
    buttonSource:     true
    #formatting:       ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6']
    plugins:          ['imagemanager', 'fontcolor', 'inlinestyle', 'filemanager', 'table', 'video', 'definedlinks']
    lang:             CMS.locale
    convertDivs:      false
    minHeight:        350


