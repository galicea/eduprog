var surly = surly || {};

surly.panel = (function () {
	var module = {};

	var targetUrl;
	var isMobile;

	var parsePageInfo = function () {
		$.ajax({
			url: '/panel/info/',
			type: "POST",
			data: {
				url: targetUrl,
				hash: $('#hash').val(),
				time: $('#time').val()
			},
			success: function (data) {
				if (data.curlFail) {
					return;
				}

				document.title = data.title;

				// add parent.redirect if frameDeny
				if (data.frameDeny || (data.isHttps && data.sslCertFail)) {
					if (!frameDenyDialogIsOpen() && alertDialogIsOpen()) {
						var iframeRedBtn = $('#site_iframe').contents().find('.b-alert__btn.b-alert__btn_red');
						var externalUrl = iframeRedBtn.attr('href');

						if (isWwwRequired(data) && !externalUrl.match(/^\/external\?url=www\./)) {
							externalUrl = '/external?url=www.' + encodeURIComponent(targetUrl);
						}

						iframeRedBtn.attr('onClick', 'parentRedirect("' + externalUrl + '");');
					}
					else if (!frameDenyDialogIsOpen()) {
						var url = (isWwwRequired(data) ? 'www.' : '') + encodeURIComponent(targetUrl);
						$('#site_iframe').attr('src', '/alert/frameDenyDialog?targetUrl=' + url);
					}
				}
				else if (isWwwRequired(data)) {
					if (alertDialogIsOpen()) {
						var iframeRedBtn = $('#site_iframe').contents().find('.b-alert__btn.b-alert__btn_red');
						var externalUrl = iframeRedBtn.attr('href');

						if (!externalUrl.match(/^\/external\?url=www\./)) {
							externalUrl = '/external?url=www.' + encodeURIComponent(targetUrl);
							iframeRedBtn.attr('href', externalUrl);
						}
					}
					else if (!$('#site_iframe').attr('src').match(/^\/external\?url=www\./)) {
						$('#site_iframe').attr('src', '/external?url=www.' + encodeURIComponent(targetUrl));
					}
				}

                if (isWwwRequired(data)) {
                    var closeBtn = $(".b-panel .-close");
                    var closeUrl = closeBtn.attr('onclick');

                    if (!closeUrl.match(/^\/external\?url=www\./)) {
                        closeUrl = "parent.window.location = '/external?url=www." + encodeURIComponent(targetUrl) + "'";
                        closeBtn.attr('onclick', closeUrl);
                    }
                }

				if (data.faviconHref) {
					$('link[rel="shortcut icon"]').attr('href', data.faviconHref);
					if (!isMobile) {
						$('img.site-favicon').attr('src', data.faviconHref);
					}
				}

				if (data.meta) {
					var meta = '';
					$.each( data.meta, function( name, content ) {
						var metaTag = $('meta[name="' + name + '"]');
						if (metaTag.length) {
							metaTag.attr('content', content);
						}
						else {
							meta += '<meta name="' + name + '" content="' + content + '" />';
						}
					});

					if (meta) {
						$("head").append(meta);
					}
				}

				if (data.openGraph) {
					var openGraph = '';
					$.each( data.openGraph, function( index, ogTag ) {
						openGraph += '<meta property="' + ogTag.property + '" content="' + ogTag.content + '" />';
					});

					if (openGraph) {
						$("head").append(openGraph);
					}
				}

				if (data.viewport && isMobile) {
					if ($('meta[name=viewport]').length) {
						$('meta[name=viewport]').attr('content', data.viewport);
					}
					else {
						$('head').append('<meta name="viewport" content="' + data.viewport + '" />');
					}
				}
			}
		});
	};

	var isWwwRequired = function (data) {
		return ((data.isHttps && data.httpsWww) || (!data.isHttps && data.httpWww));
	}

	var frameDenyDialogIsOpen = function () {
		var src = $('#site_iframe').attr('src');
		return !!src.match(/^\/alert\/frameDenyDialog/);
	}

	var alertDialogIsOpen = function () {
		var src = $('#site_iframe').attr('src');
		return !!src.match(/^\/alert\//);
	}

	module.parsePageInfo = function (argTargetUrl, argIsMobile) {
		targetUrl = argTargetUrl;
		isMobile = argIsMobile;

		parsePageInfo();
	};

	return module;
}());