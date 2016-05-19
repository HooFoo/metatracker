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
    $(document).ready(@ajustBanners)
    $(document).ready(@bindCallbacks)
    $(document).ready(@checkQuery)

  bindCallbacks: =>
    console.log('Bind callbacks')
    @bindEvents('#query-button', 'click', @onSearchButtonClicked)
    @bindEvents('#search-form', 'ajax:success', @onResultsRecieved)

  applyPagination: =>
    console.log("Apply pagination")
    @bindEvents('#paginator_top,#paginator_bottom', 'ajax:success', @onResultsRecieved )
    @bindEvents('#paginator_top,#paginator_bottom', 'click', @showLoader )

  ajustBanners: ->
    id = 'top-banner'
    console.log('ajust banners')
    if(document.getElementById)
      newheight = document.getElementById(id).contentWindow.document.body.scrollHeight;
      newwidth = document.getElementById(id).contentWindow.document.body.scrollWidth;
    document.getElementById(id).height = (newheight) + "px";
    document.getElementById(id).width = (newwidth) + "px";

  checkQuery: =>
    path = window.location.pathname.replace(/(\/)|(_)/g,' ').trim()
    if path.length>1
      $('#query').val(path)
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
