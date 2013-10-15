$(function() {
	// var leaving_date = $("#leaving_date");
	// leaving_date.datepicker();

	// leaving_date.on('change', function(){
	// 	var now = new Date(),
	// 		date = $(this),
	// 		dateValue = new Date(date.val()),
	// 		dateError = $("#leaving_date_error");

	// 	if (dateValue < now) {
	// 		$(this).css('border-color', 'red');
	// 		dateError.show();
	// 	} else {
	// 		$(this).css('border-color', 'rgb(204, 204, 204)');
	// 		dateError.hide();
	// 	}
	// });

	// Pretty Photo
	$("a[rel^='prettyPhoto']").prettyPhoto();

	// Toggle menu for FAQ page
	var toggle_li	= $("#questions li");

	toggle_li.children('.the_answer').hide();
	toggle_li.children('.the_question').on('click', function(){
		var answer = $(this).siblings('.the_answer');
		if (answer.is(':hidden')) {
			answer.slideDown('fast');
		} else {
			answer.slideUp('fast');
		}
	});

});

