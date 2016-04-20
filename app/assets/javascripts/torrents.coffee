# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class View
  constructor: ->
    this.init()

  init: ->
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
    this.bindEvents(document,'domReady',this.ajustBanners)

  ajustBanners: ->
    id = 'top-banner'
    if(document.getElementById)
      newheight = document.getElementById(id).contentWindow.document.body.scrollHeight;
      newwidth = document.getElementById(id).contentWindow.document.body.scrollWidth;
    document.getElementById(id).height = (newheight) + "px";
    document.getElementById(id).width = (newwidth) + "px";

  bindEvents: (element,name,cb) ->
    $(element).on(name,cb)

new View
