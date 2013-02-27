d = false

jQuery ->
    svgLoaded().done svgSetup
    $('#next').on 'click', nextQuestion
    $('#reveal').on 'click', reveal
    checkReady = ->
        if $('#geo').get(0).getSVGDocument()
            d.resolve()
        else
            setTimeout checkReady, 100

    checkReady()


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
county_list = []

svgStyle = (src) ->
    style = $(svg().get(0).createElementNS "http://www.w3.org/1999/xhtml", "link")
    style.attr 'rel',  'stylesheet'
    style.attr 'type', 'text/css'
    style.attr 'href', src
    svg('path').get(0).parentNode.appendChild style.get(0)

shuffle = (arr) ->
    i = arr.length
    return [] unless i > 0

    while --i
        j = Math.floor(Math.random() * (i+1))
        [arr[i], arr[j]] = [arr[j], arr[i]] # use pattern matching to swap

svgSetup = ->
    svgStyle $('link[rel="svg-styles"]').attr('href')

    elems = svg('path')
    svg('path').on('click', objectClicked)
    list = $('#list')

    elems.each (idx, county)->
        county = $(county)
        name = county.attr('inkscape:label')
        counties[ name ] = county
        county_list.push county

    shuffle county_list
    nextQuestion()

nextQuestion = ->
    $('#selected').text('')
    wanted = county_list.shift()
    $('#wanted').text wanted.attr('inkscape:label')

reveal = ->
    svg('.selected').removeClass('selected')
    counties[ $('#wanted').text() ].addClass('selected')

objectClicked = (ev) ->
    county = $(ev.target)
    svg('.selected').removeClass('selected')
    county.addClass('selected')
    name = county.attr('inkscape:label')
    $('#selected').text name
    attempts = $('#attempts')
    attempts.text( Number(attempts.text()) + 1 )
