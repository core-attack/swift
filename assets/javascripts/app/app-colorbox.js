$(function() {
  window.boxOptions = { opacity: 0.85, loop: false, current: "{current} / {total}", previous: "←", next: "→", close: "Esc", maxWidth: "80%", maxHeight: "100%", transition: "elastic" };
  if ($.browser.msie && $.browser.version < '8.0.0')
    window.boxOptions.transition = "none";
  $('[rel^="box-"]').colorbox(window.boxOptions);
});
$(document).bind('cbox_load', function(){
  $('#cboxTextOverlay').remove();
});

$(document).bind('cbox_closed', function(){
  $(document.body).css('overflow-y', 'auto');
});

$(document).bind('cbox_complete', function(){
  var el = $.colorbox.element();
  var text = '<small>' + el.prop('title') + '</small>';
  $('#cboxContent').append("<div id='cboxTextOverlay'>"+text+"</div>");
  $('#cboxTitle').remove();
  $('#cboxContent').hover(function() {
    $('#cboxTextOverlay').fadeIn('fast');
  }, function() {
    $('#cboxTextOverlay').fadeOut('fast');
  });
  $('#cboxOverlay').append('<div id="cboxControls"></div>');
  $('#cboxClose, #cboxCurrent, #cboxPrevious, #cboxNext').appendTo('#cboxControls');
  $('#cboxClose, #cboxCurrent, #cboxPrevious, #cboxNext').click(function(e) {
    e.stopPropagation();
  });
  $(document.body).css('overflow-y', 'scroll');
});

$(document).bind('language', function(){
  $('#language').click(function() {
    var a = $.a.element();
    if (a.className == "rus")
    {  
      a.className = "rus ACTIVE"
      var arr = getElementsByName('eng')
      if (arr.length != 0)
        arr[0].className = "eng"
    }
    else if (a.className == "eng")
    {
      a.className = "eng ACTIVE"
      var arr = getElementsByName('rus')
      if (arr.length != 0)
        arr[0].className = "rus"
    }
  });
});