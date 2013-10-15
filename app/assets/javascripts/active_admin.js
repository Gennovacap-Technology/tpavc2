//= require active_admin/base
//= require ckeditor/init

function validate_file(file) {

	var error 				= false;
	var allowed_types = new Array(
		"application/pdf"
	);

	// Don't send more than 5 files
	if(file[0].files.length > 5) {
		file.after('<p class="inline-errors">You can only upload 5 files at a time.</p>');
		return false;
	}

	// http://www.feedforall.com/mime-types.htm
	$.each(file[0].files, function(index, f){

		// validates extensions    
		if( allowed_types.indexOf(f.type) !== 0 ) {
			file.after('<p class="inline-errors">You can only upload PDFs.</p>');
			error = true;
			return false;
		}

		// validates size
		if( f.size > 15728640 ) {
			file.after('<p class="inline-errors">The max filesize is 15MB.</p>');
			error = true;
			return false;
		}

	});

	if(error) {
		return false;
	}

	return true;

}

$(function(){

	$(".has_many > h3").remove(); // Remove the unnecessary H3 tag from the has_many entries

	// Hide the inputs
	var documental    		= $('#visa_document_package_input'),
		documental_input 	= $("#visa_citizenship_us_citizen"),
		supplemental  		= $('#visa_supplemental_package_input'),
		supplemental_input 	= $("#visa_citizenship_foreign_national");

	if(documental_input.is(':checked')) {
		supplemental.hide();
	} else {
		documental.hide();
	}

	// Make the switch on change
	$("#visa_citizenship_us_citizen").on('click', function(){
		documental.show();
		supplemental.hide();		
	});
	$("#visa_citizenship_foreign_national").on('click', function(){
		documental.hide();
		supplemental.show();	
	});

	// Validates the form inputs
	$("#new_visa, #edit_visa").on('submit', function(){
		
		var documental    = $('#visa_document_package');
		var supplemental  = $('#visa_supplemental_package');

		var documental_validation 	= validate_file(documental);
		var supplemental_validation = validate_file(supplemental);

		if (!documental_validation || !supplemental_validation) {
			return false;
		}

	});

})();