initiate_scroll = () ->
	iscroll = $('#infinite-scroll')
	base_url = iscroll.data('infinite-url')
	current_page = iscroll.data('infinite-current-page')

	current_wait = null

	loading = false
	if iscroll.length > 0
		$(window).scroll(() ->
			if loading
				return
			if current_wait != null
				cancelTimeout(current_wait)

			if iscroll.data('infinite-last-page-reached') == 'true'
				return

			load_extra_items = () ->
				leftOfPage = $(document).height() - ($(window).scrollTop() + $(window).height())
				if (leftOfPage < 100)
					loading = true
					current_wait = null
					iscroll.find('.loading').fadeIn()
					$.ajax(
						base_url
						data:
							page: ++current_page
						complete: () ->
							loading = false
							iscroll.find('.loading').fadeOut()
						error: () ->
							current_page--
						dataType: 'script'
					)
				else
					current_wait = null

			current_wait = setTimeout(load_extra_items, 500);
		)

$(() ->
	initiate_scroll()
)