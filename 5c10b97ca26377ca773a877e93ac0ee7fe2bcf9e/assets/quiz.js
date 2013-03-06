(function() {
  var counties, county_list, d, nextQuestion, objectClicked, reveal, shuffle, svg, svgLoaded, svgSetup, svgStyle,
    __slice = [].slice;

  d = false;

  jQuery(function() {
    var checkReady;
    svgLoaded().done(svgSetup);
    $('#next').on('click', nextQuestion);
    $('#reveal').on('click', reveal);
    checkReady = function() {
      if ($('#geo').get(0).getSVGDocument()) {
        return d.resolve();
      } else {
        return setTimeout(checkReady, 100);
      }
    };
    return checkReady();
  });

  svgLoaded = function() {
    d = $.Deferred();
    return d.promise();
  };

  svg = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (!window.svg) {
      window.svg = $('#geo').get(0).getSVGDocument();
    }
    if (args) {
      return $.apply(null, __slice.call(args).concat([window.svg]));
    } else {
      return window.svg;
    }
  };

  counties = {};

  county_list = [];

  svgStyle = function(src) {
    var style;
    style = $(svg().get(0).createElementNS("http://www.w3.org/1999/xhtml", "link"));
    style.attr('rel', 'stylesheet');
    style.attr('type', 'text/css');
    style.attr('href', src);
    return svg('path').get(0).parentNode.appendChild(style.get(0));
  };

  shuffle = function(arr) {
    var i, j, _ref, _results;
    i = arr.length;
    if (!(i > 0)) {
      return [];
    }
    _results = [];
    while (--i) {
      j = Math.floor(Math.random() * (i + 1));
      _results.push((_ref = [arr[j], arr[i]], arr[i] = _ref[0], arr[j] = _ref[1], _ref));
    }
    return _results;
  };

  svgSetup = function() {
    var elems, list;
    svgStyle($('link[rel="svg-styles"]').attr('href'));
    elems = svg('path');
    svg('path').on('click', objectClicked);
    list = $('#list');
    elems.each(function(idx, county) {
      var name;
      county = $(county);
      name = county.attr('inkscape:label');
      counties[name] = county;
      return county_list.push(county);
    });
    shuffle(county_list);
    return nextQuestion();
  };

  nextQuestion = function() {
    var wanted;
    $('#selected').text('');
    wanted = county_list.shift();
    return $('#wanted').text(wanted.attr('inkscape:label'));
  };

  reveal = function() {
    svg('.selected').removeClass('selected');
    return counties[$('#wanted').text()].addClass('selected');
  };

  objectClicked = function(ev) {
    var attempts, county, name;
    county = $(ev.target);
    svg('.selected').removeClass('selected');
    county.addClass('selected');
    name = county.attr('inkscape:label');
    $('#selected').text(name);
    attempts = $('#attempts');
    return attempts.text(Number(attempts.text()) + 1);
  };

}).call(this);
