(function() {
  var answer_known, counties, county_list, d, nextQuestion, objectClicked, reveal, select, shuffle, svg, svgLoaded, svgSetup, svgStyle, wanted,
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

  answer_known = false;

  wanted = null;

  nextQuestion = function() {
    var cell, name, stats, tmpl;
    answer_known = false;
    $('#selected').text('');
    wanted = county_list.shift();
    name = wanted.attr('inkscape:label');
    $('#wanted').text(name);
    svg('path').removeClass('tried');
    tmpl = $('#stat-row');
    stats = tmpl.clone();
    stats.removeAttr('id');
    stats.removeAttr('style');
    stats.prependTo(tmpl.parent());
    return cell = stats.find('td.name').text(name);
  };

  select = function(region) {
    svg('.selected').removeClass('selected');
    return region.addClass('selected');
  };

  reveal = function() {
    answer_known = true;
    return select(counties[$('#wanted').text()]);
  };

  objectClicked = function(ev) {
    var attempts, county, current, current_attempts, name;
    if (answer_known) {
      return;
    }
    county = $(ev.target);
    select(county);
    name = county.attr('inkscape:label');
    current = $('#stats tr').first();
    current_attempts = current.find('.attempts');
    current_attempts.text(Number(current_attempts.text()) + 1);
    if (county[0] === wanted[0]) {
      answer_known = true;
      current.find('.success').text('Yes');
    } else {
      county.addClass('tried');
    }
    $('#selected').text(name);
    attempts = $('#attempts');
    return attempts.text(Number(attempts.text()) + 1);
  };

}).call(this);
