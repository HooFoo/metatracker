# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class View
  constructor: ->
    this.init()

  init: ->
    self = this
    $('#query').ready ->
      ac_url = $('#query').data('autocomplete-source')
      bh = new Bloodhound
            datumTokenizer: (datum) ->
              Bloodhound.tokenizers.whitespace(datum)
            queryTokenizer: Bloodhound.tokenizers.whitespace
            remote:
              url: ac_url
              wildcard: '%QUERY'
      bh.initialize()
      $('#query').typeahead null
        ,
        source: bh
    $(document).ready(@bindCallbacks)
    $(document).ready(@checkQuery)
    @onQueryValueChanged()

  bindCallbacks: =>
    console.log('Bind callbacks')
    @bindEvents('#query-button', 'click', @onSearchButtonClicked)
    @bindEvents('#search-form', 'ajax:success', @onResultsRecieved)
    @bindEvents('#query','change paste keyup',@onQueryValueChanged)
    @bindEvents('#backspace','click',@onBackspaceClick)


  applyPagination: =>
    console.log("Apply pagination")
    @bindEvents('#paginator_top,#paginator_bottom', 'ajax:success', @onResultsRecieved )
    @bindEvents('#paginator_top,#paginator_bottom', 'click', @showLoader )


  checkQuery: =>
    path = decodeURIComponent(window.location.pathname).replace(/(\/)|(_)/g,' ').trim()
    if path.length>1
      $('#query').val(path).change()
      $('#query-button').submit()

  onSearchButtonClicked: =>
    console.log('Button Clicked')
    q = $('#query').val()
    prepared = '/'+@prepareQuery(q)
    window.history.pushState("Get-torrent", "Search: "+q, prepared);
    @showLoader()

  onResultsRecieved: (e, data, status, xhr) =>
    console.log('Result recieved')
    $('#search-result').html(xhr.responseText)
    @applyPagination()
    @hideLoader()

  onQueryValueChanged: ->
    console.log('Query changed')
    q = $('#query').val()
    if q? and q.length >0
      $('#backspace').css({ visibility: 'visible'})
    else
      console.log('here')
      $('#backspace').css({visibility:'hidden'})

  onBackspaceClick: ->
    console.log('Backspace clicked')
    $('#query').val('')

  prepareQuery: (q) ->
    q.replace(/(\/)|(\s)/g,'_').trim()

  bindEvents: (element,name,cb) ->
    $(element).on(name,cb)

  showLoader: ->
    $('#search-result').hide(500)
    $('#loader').show(500)

  hideLoader: ->
    $('#search-result').show(500)
    $('#loader').hide(500)


window.ViewController = new View
