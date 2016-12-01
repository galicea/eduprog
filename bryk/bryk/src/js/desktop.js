
window.App = window.App || {}

$(function(){ // DOM ready

    var is_ipad = !!navigator.userAgent.match(/iPad/i)

    $("body").toggleClass("not_ipad", !is_ipad)

    /***********************************************************************
     * abuse btn
     */
    var is_abuse_form_show = false

    $(".b-abuse").on("click", abuse_click)

    if (is_ipad) {
        $(window).on('orientationchange', function(){
            hide_statictics()
            hide_all_dropdowns()
            App.abuse.hide('form')
            is_abuse_form_show = false
        })
    }
    else {
        $(".b-abuse").hover(abuse_hover_in, abuse_hover_out)
    }

    App.abuse = { show: abuse_show
                , hide: abuse_hide
                }

    function abuse_click(e){

        // click inside form
        if ($(e.target).closest(".b-abuse-popup").length) {
            return
        }

        if (is_abuse_form_show) {
            App.abuse.hide('form')
            is_abuse_form_show = false
            if (!is_ipad){
                App.abuse.show('tooltip')
            }
        }
        else {
            if (!is_ipad){
                App.abuse.hide('tooltip')
            }
            hide_statictics()
            hide_all_dropdowns()
            App.abuse.show('form')
            is_abuse_form_show = true
        }
    }

    function abuse_hover_in(){
        if (!is_abuse_form_show) {
            App.abuse.show('tooltip')
        }
    }

    function abuse_hover_out(){
        if (!is_abuse_form_show) {
            App.abuse.hide('tooltip')
        }
    }

    function abuse_show(popup_name){
        var $handler  = $(".b-abuse")
          , h_width   = $handler.outerWidth()
          , h_left    = $handler.offset().left - $(".b-panel").offset().left

          , win_width = is_ipad ? window.innerWidth : $(window).width()

          , $abuse_popup  = $handler.find(".b-abuse-popup.-" + popup_name)
          , t_width   = $abuse_popup.outerWidth()

          , left      = -(t_width - h_width) / 2

          , out       = t_width + (h_left+left) - win_width

          , $arrow    = $abuse_popup.find(".b-abuse-arrow")
          , a_left    = t_width/2

        if (out > 0) {
            left   -= out + 10
            a_left += out + 10 - (popup_name == 'form' ? 1 : 0) // -1px boder
        }

        $handler.addClass(CLASS_active)

        $arrow.css({ left: a_left })

        $abuse_popup.css({ left: left }).show()
    }

    function abuse_hide(popup_name){
        var $handler     = $(".b-abuse")
          , $abuse_popup = $handler.find(".b-abuse-popup.-" + popup_name)

        $handler.removeClass(CLASS_active)

        $abuse_popup.hide()
    }

    function hide_abuse_form(){
        App.abuse.hide('form')
        is_abuse_form_show = false
    }

    /***********************************************************************
     * menu and Resent posts hover(click)
     */
    var CLASS_active = "-active"
      , $dropdown_wrapper = $(".b-dropdown__wrapper")

    if (is_ipad) {
        $dropdown_wrapper.click(iPad_click_dropdown)
    }
    else {
        $dropdown_wrapper.hover(
            function(e) {
                dropdown_show.call(this)
            }
        ,   function(e) {
//!                dropdown_hide.call(this)
            }
        );
        $(".b-dropdown").hover(
            function(e) {
            }
        ,   function(e) {
//alert(e);
                //dropdown_hide.call(this)
$(".b-dropdown").hide();
            }

        );
    }

    function iPad_click_dropdown(e){

        // click inside dropdown
        if ($(e.target).closest(".b-dropdown").length) {
            return
        }

        var $wrapper  = $(this)
          , $dropdown = $wrapper.find(".b-dropdown")

        if ($dropdown.is(":visible")){
            hide_all_dropdowns()
        }
        else {
            hide_abuse_form()
            hide_statictics()
            hide_all_dropdowns()

            dropdown_show.call(this)
        }

    }

    function dropdown_show(){
        var $wrapper  = $(this)
          , $item     = $wrapper.find(".b-item")
          , $dropdown = $wrapper.find(".b-dropdown")
            $items    = $item.closest(".b-items")

          , list_urls  = $dropdown.hasClass("b-list_urls")
          , left       = 0
          , width      = 0

          , $site      = $(".b-site")
          , height     = $site.height()

        $item.addClass(CLASS_active)

        if ($items.width() <= 1280 && list_urls) {
            left  = 0
            width = $item.offset().left + $item.outerWidth()
        }
        else {
            left  = $item.offset().left - $items.offset().left
            width = $item.outerWidth()
            if (list_urls) {
                left -= 10
                width += 10
            }
        }

        $dropdown
            .css({ left:   left
                 , width:  width
                 , height: ""
                 })

        $dropdown.show()

        var dd_height = $dropdown.height()

        if (dd_height > height) {
            $dropdown.css({ height: height - 20 })
        }
    }

    function dropdown_hide(){
        var $wrapper  = $(this)
          , $item     = $wrapper.find(".b-item")
          , $dropdown = $wrapper.find(".b-dropdown")

        $item.removeClass(CLASS_active)
        $dropdown.hide()

    }

    function hide_all_dropdowns(){
        var $dd_wrapper = $(".b-dropdown__wrapper")

        $dd_wrapper.each(function(){
            var $wrapper = $(this)
              , $handler = $wrapper.find(".b-item")
              , $dropdown = $wrapper.find(".b-dropdown")

            $handler.removeClass(CLASS_active)
            $dropdown.hide()
        })
    }

    /***********************************************************************
     * statistics popup
     */
    var CLASS_selected = "-selected"
      , $wrapper_stat  = $('.b-item.-indicators')
      , $popup_stat    = $wrapper_stat.find('.b-list_indicators')

    var hide_stat_timeout;

    if (is_ipad){
        $wrapper_stat.click(iPad_click_statistics)
    }
    else {
        $wrapper_stat.hover(
            function() {
                if (hide_stat_timeout) {
                    clearTimeout(hide_stat_timeout);
                }
                else {
                    show_statistics();
                }
            },
            function() {
                hide_stat_timeout = setTimeout(hide_statictics,500);
            }
        );
    }

    function iPad_click_statistics(e){

        // click inside stat
        if ($(e.target).closest(".b-list_indicators").length) {
            return
        }

        if ($popup_stat.is(":visible")){
            hide_statictics()
        }
        else {
            hide_abuse_form()
            hide_all_dropdowns()
            show_statistics()
        }
    }

    function show_statistics() {
        if ($wrapper_stat.hasClass(CLASS_selected)) {
            return;
        }
        $wrapper_stat.addClass(CLASS_selected);
        $popup_stat
            .css({ left: ($wrapper_stat.outerWidth() - $popup_stat.outerWidth()) / 2 })
            .show();

        reset_progress();
        animate_progress();
    }

    function hide_statictics() {
        $wrapper_stat.removeClass(CLASS_selected);
        $popup_stat.hide();
        hide_stat_timeout = false;
    }

    /***********************************************************************
     * after form send
     * - hide the form
     * - show a message
     * - hide the message after 2 sec
     */
//    $(".b-form-btn button").click(function(){
//
//        // ajax - send form
//
//        App.abuse.hide("form")
//        App.abuse.show("message")
//
//        setTimeout(function(){
//            App.abuse.hide("message")
//        }, 2000)
//    })

    function animate_progress() {
        var $progress = $wrapper_stat.find('.b-progress');

        $progress.each(function() {
            var $item  = $(this)
                , $inner = $item.find(".b-progress-inner")
                , value  = $item.data("value")

            $inner.stop().animate({width: value})
        })
    }

    function reset_progress() {
        var $progress = $wrapper_stat.find(".b-progress")

        $progress.each(function() {
            var $item  = $(this)
                , $inner = $item.find(".b-progress-inner")

            $inner.stop().css({width: 0})
        })
    }

	function checkWindowVisibility() {
		var stateKey, eventKey, keys = {
			hidden: "visibilitychange",
			webkitHidden: "webkitvisibilitychange",
			mozHidden: "mozvisibilitychange",
			msHidden: "msvisibilitychange"
		};
		for (stateKey in keys) {
			if (stateKey in document) {
				eventKey = keys[stateKey];
				break;
			}
		}

		if (!eventKey) {
			return false;
		}

		return (!document[stateKey]);
	}

	var came = false;
	var hideTimeout;

    show_statistics();

    // checkWindowVisibility не работает на айпаде
    // окошко статы не пропадает
	if (checkWindowVisibility()) {
		hideTimeout = setTimeout(hide_statictics, 2000);
	}
	else {
        // на айпаде при первом клике на стату она появл. и пропадает
        // поэтому поставил проверку что для айпада не надо
        if (!is_ipad){
    		$(window).focus(function() {
    			if( came === false) {
    				came = true;
    				hideTimeout = setTimeout(hide_statictics, 2000);
    			}
    		});
        }
	}

    // т.к. на айпаде убирали ховеры - делаем проверку на айпад
    if (!is_ipad){
        $('.b-list_indicators').hover(
            function() { clearTimeout(hideTimeout) },
            function() { }
        );
    }

});
