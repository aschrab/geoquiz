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

answer_known = false
wanted = null

nextQuestion = ->
    answer_known = false
    $('#selected').text('')
    wanted = county_list.shift()
    name = wanted.attr('inkscape:label')
    $('#wanted').text name

    svg('path').removeClass 'tried'

    tmpl = $('#stat-row')
    stats = tmpl.clone()
    stats.removeAttr 'id'
    stats.removeAttr 'style'
    stats.prependTo tmpl.parent()
    cell = stats.find('td.name').text name

select = (region) ->
    svg('.selected').removeClass('selected')
    region.addClass('selected')

reveal = ->
    answer_known = true
    select counties[ $('#wanted').text() ]

objectClicked = (ev) ->
    return if answer_known
    county = $(ev.target)
    select county
    name = county.attr('inkscape:label')

    current = $('#stats tr').first()
    current_attempts = current.find('.attempts')
    current_attempts.text( Number(current_attempts.text()) + 1 )

    if county[0] == wanted[0]
        answer_known = true
        current.find('.success').text 'Yes'
    else
        county.addClass 'tried'

    $('#selected').text name
    attempts = $('#attempts')
    attempts.text( Number(attempts.text()) + 1 )
