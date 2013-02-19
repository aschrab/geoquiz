d = false

jQuery ->
    $('#doSetup').on 'click', -> d.resolve()

    svgLoaded().done svgSetup

svgLoaded = ->
    d = $.Deferred()
    d.promise()

svg = (args...) ->
    unless window.svg
        window.svg = $('#geo').get(0).getSVGDocument()
    if args
        $( args...,  window.svg)
    else
        window.svg

counties = {}

svgStyle = (src) ->
    style = $(svg().get(0).createElementNS "http://www.w3.org/1999/xhtml", "link")
    style.attr 'rel',  'stylesheet'
    style.attr 'type', 'text/css'
    style.attr 'href', src
    svg('path').get(0).parentNode.appendChild style.get(0)

svgSetup = ->
    svgStyle('assets/map.css')

    elems = svg('path')
    svg('path').on('click', objectClicked)
    list = $('#list')

    elems.each (idx, county)->
        county = $(county)
        name = county.attr('inkscape:label')
        counties[ name ] = county

objectClicked = (ev) ->
    county = $(ev.target)
    county.css('fill', '#ff0000')
    name = county.attr('inkscape:label')
    $('#county-name').text( name )
