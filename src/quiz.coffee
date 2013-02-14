jQuery ->
    $('#doSetup').on('click', svgSetup)
    $('#geo').on('load', svgSetup)

svg = (args...) ->
    unless window.svg
        window.svg = $('#geo').get(0).getSVGDocument()
    $( args...,  window.svg)

counties = {}

svgSetup = ->
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
