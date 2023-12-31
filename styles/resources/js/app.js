/*****
* CONFIGURATION
*/

//Main navigation
$.navigation = $('nav > ul.nav');

$.panelIconOpened = 'fa-chevron-down';
$.panelIconClosed = 'fa-chevron-up';

/*
//Default colours
$.brandPrimary =  '#20a8d8';
$.brandSuccess =  '#4dbd74';
$.brandInfo =     '#63c2de';
$.brandWarning =  '#f8cb00';
$.brandDanger =   '#f86c6b';

$.grayDark =      '#2a2c36';
$.gray =          '#55595c';
$.grayLight =     '#818a91';
$.grayLighter =   '#d1d4d7';
$.grayLightest =  '#f8f9fa';
*/

'use strict';

if (!$.isNumeric(msieversion())) {
	$(window).on('load', function () {
	  $("body").removeClass("preload");
	});
}

/****
* MAIN NAVIGATION
*/

$(document).ready(function($){

  init();

  toastr.options = {
	  "closeButton": false,
	  "debug": false,
	  "newestOnTop": false,
	  "progressBar": true,
	  "positionClass": "toast-top-right",
	  "preventDuplicates": false,
	  "onclick": null,
	  "showDuration": "300",
	  "hideDuration": "1000",
	  "timeOut": "5000",
	  "extendedTimeOut": "1000",
	  "showEasing": "swing",
	  "hideEasing": "linear",
	  "showMethod": "fadeIn",
	  "hideMethod": "fadeOut"
  }

  //check if BLOCKED_BY_CLIENT
  if (typeof(cookieconsent) != "undefined") {
	window.cookieconsent.initialise({
		"palette": {
			"popup": {
				"background": "#000"
			},
			"button": {
				"background": "transparent",
				"text": "#f1d600",
				"border": "#f1d600"
			}
		},
		"content": {
			"message": "This website uses cookies, by using this website you consent to all of our cookies.",
			"dismiss": "Got it!",
			"link": "Learn more",
			"href": "https://cookiesandyou.com"
		},
		"position": "bottom-right"
	});
  }

  //stop modal adding padding and margins to body and nav elements
  $.fn.modal.Constructor.prototype._setScrollbar = function () {};

  //move modals
  $("#modal-container").append( $("div.modal") );

  // Add class .active to current link
  /*
  $.navigation.find('a').each(function(){

    var cUrl = String(window.location).split('?')[0];

    if (cUrl.substr(cUrl.length - 1) == '#') {
      cUrl = cUrl.slice(0,-1);
    }

    if ($($(this))[0].href==cUrl) {
      $(this).addClass('active');

      $(this).parents('ul').add(this).each(function(){
        $(this).parent().addClass('open');
      });
    }
  });
  */

  // Dropdown Menu
  $.navigation.on('click', 'a', function(e){

    if ($.ajaxLoad) {
      e.preventDefault();
    }

    if ($(this).hasClass('nav-dropdown-toggle')) {
      $(this).parent().toggleClass('open');
      var navState = [];
      $("nav > ul > li.nav-item").each(function( index ) {
        if ($( this ).hasClass("open")) {
        navState[index] = "open";
        }
      });
      localStorage.setItem("omicron-navState", navState);
      resizeBroadcast();
    }

  });

  function resizeBroadcast() {

    var timesRun = 0;
    var interval = setInterval(function(){
      timesRun += 1;
      if(timesRun === 5){
        clearInterval(interval);
      }
      if (navigator.userAgent.indexOf('MSIE') !== -1 || navigator.appVersion.indexOf('Trident/') > 0) {
        var evt = document.createEvent('UIEvents');
        evt.initUIEvent('resize', true, false, window, 0);
        window.dispatchEvent(evt);
      } else {
         window.dispatchEvent(new Event('resize'));
      }
    }, 62.5);
  }

  $('.flyingfleet').click(function(e){
    $('.flyingfleet').not(this).popover('hide');
  });

  /* ---------- Menu States ---------- */
  var navState = localStorage.getItem("omicron-navState");
  if (navState) {
    navState = navState.split(",");

    $("nav > ul > li.nav-item").each(function( index ) {
      if(navState[index] == 'open'){
        $(this).toggleClass('open');
      }
    });
  }

  var lsCollapsed = JSON.parse(localStorage.getItem("omicron-collapse"));
  if (!lsCollapsed) {
    lsCollapsed = [];
  }
  lsCollapsed.forEach(function(v) {
	if($("#"+v).length != 0) {
		$('#'+v).parent().find('i').each( function( i, el ) {
			var elem = $( el );
			if (elem.hasClass($.panelIconOpened) || elem.hasClass($.panelIconClosed)) {
				var toggle = localStorage.getItem("omicron-collapse-"+v);
				$('#'+v).collapse(toggle);
				if (toggle == 'hide') {
					$('#'+v).parent().find('i').eq(i).removeClass($.panelIconClosed).addClass($.panelIconOpened);
				} else {
					$('#'+v).parent().find('i').eq(i).removeClass($.panelIconOpened).addClass($.panelIconClosed);
				}
			}
		});
	}
  });

  var sidebarNav = localStorage.getItem("omicron-sidebarNav");
  sidebarNav = sidebarNav=='true';
  $('body').toggleClass('sidebar-hidden', sidebarNav);
  
  var sidebarMinimized = localStorage.getItem("omicron-sidebarMinimized");
  sidebarMinimized = sidebarMinimized=='true';
  $('body').toggleClass('sidebar-minimized', sidebarMinimized);
  $('body').toggleClass('brand-minimized', sidebarMinimized);
  
  var asideNav = localStorage.getItem("omicron-asideNav");
  asideNav = asideNav=='true';
  $('body').toggleClass('aside-menu-hidden', asideNav);

  /* ---------- Main Menu Open/Close, Min/Full ---------- */
  $('.sidebar-toggler').click(function(){
    /* var $this = $(this); */
    sidebarNav = !sidebarNav;
    $('body').toggleClass('sidebar-hidden', sidebarNav);
    localStorage.setItem("omicron-sidebarNav", sidebarNav);
    resizeBroadcast();
  });

  $('.sidebar-minimizer').click(function(){
    /* var $this = $(this); */
    sidebarMinimized = !sidebarMinimized;
    $('body').toggleClass('sidebar-minimized', sidebarMinimized);
    localStorage.setItem("omicron-sidebarMinimized", sidebarMinimized);
    resizeBroadcast();
  });

  $('.brand-minimizer').click(function(){
    $('body').toggleClass('brand-minimized');
  });

  $('.aside-menu-toggler').click(function(){
    /* var $this = $(this); */
    asideNav = !asideNav;
    $('body').toggleClass('aside-menu-hidden', asideNav);
    localStorage.setItem("omicron-asideNav", asideNav);
    resizeBroadcast();
  });

  $('.mobile-sidebar-toggler').click(function(){
    if ($("body").hasClass("aside-mobile-show")) {
        $('body').toggleClass('aside-mobile-show');
    }
    $('body').toggleClass('sidebar-mobile-show');
    resizeBroadcast();
  });

  $('.mobile-aside-menu-toggler').click(function(){
    if ($("body").hasClass("sidebar-mobile-show")) {
        $('body').toggleClass('sidebar-mobile-show');
    }
    $('body').toggleClass('aside-mobile-show');
    resizeBroadcast();
  });

  $('.sidebar-close').click(function(){
    $('body').toggleClass('sidebar-opened').parent().toggleClass('sidebar-opened');
  });

  $('.btn-minimize').click(function(){
    var dataTarget = $(this).attr("data-target").substr(1);
    var lsCollapsed = JSON.parse(localStorage.getItem("omicron-collapse"));
    if (!lsCollapsed) {
        lsCollapsed = [];
    }
    if ($.inArray(dataTarget, lsCollapsed) == '-1') {
        lsCollapsed.push(dataTarget);
        localStorage.setItem("omicron-collapse", JSON.stringify(lsCollapsed));
    }
    if ($(this).hasClass("collapsed")) {
        localStorage.setItem("omicron-collapse-"+dataTarget, "show");
    } else {
        localStorage.setItem("omicron-collapse-"+dataTarget, "hide");
    }
  });

  /* ---------- Disable moving to top ---------- */
  $('a[href="#"][data-top!=true]').click(function(e){
    e.preventDefault();
  });

  if ($.isNumeric(msieversion())) {
    $("body").removeClass("preload");
  }

});

/****
* CARDS ACTIONS
*/

$('.card-actions').on('click', 'a, button', function(e){

  if ($(this).hasClass('btn-close')) {
    e.preventDefault();
    $(this).parent().parent().parent().fadeOut();
  } else if ($(this).hasClass('btn-minimize')) {
    e.preventDefault();
    // var $target = $(this).parent().parent().next('.card-body').collapse({toggle: true});
    if ($(this).hasClass('collapsed')) {
      $('i',$(this)).removeClass($.panelIconOpened).addClass($.panelIconClosed);
    } else {
      $('i',$(this)).removeClass($.panelIconClosed).addClass($.panelIconOpened);
    }
  } else if ($(this).hasClass('btn-setting')) {
    e.preventDefault();
    $('#myModal').modal('show');
  }

});

$('.animated').append('<button id="bk2top" type="button" class="d-md-none btn btn-primary"><i class="fa fa-arrow-up"></i></button>');
	$(window).scroll(function () {
		if ($(this).scrollTop() != 0) {
			$('#bk2top').fadeIn();
		} else {
			$('#bk2top').fadeOut();
		}
	});
$('#bk2top').click(function(){
	$("html, body").animate({ scrollTop: 0 }, 600);
	return false;
});

/*
function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}
*/

function init() {

  /* ---------- Popover ---------- */
  $('[data-toggle="popover"]').popover({
    trigger: 'focus'
  });

}

function msieversion() {
    var ua = window.navigator.userAgent;

    var msie = ua.indexOf('MSIE ');
    if (msie > 0) {
        // IE 10 or older => return version number
        return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
    }

    var trident = ua.indexOf('Trident/');
    if (trident > 0) {
        // IE 11 => return version number
        var rv = ua.indexOf('rv:');
        return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
    }

    var edge = ua.indexOf('Edge/');
    if (edge > 0) {
       // Edge (IE 12+) => return version number
       return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
    }

    // other browser
    return false;
}