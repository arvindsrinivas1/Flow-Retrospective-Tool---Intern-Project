// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .

var animation = "";

var delayInMilliseconds = 1000;
$(document).on("focus click", ".card", function(event){
	elementID = this.id
	rubberHandler(event,$("#"+elementID));
});

function rubberHandler(event, target){
	console.log("WIGGLE WIGGLE");	
	animation = "rubberBand";
	$(document.body).css({"overflow-x":"hidden"});
	target.addClass("animated");
	target.addClass("rubberBand");
	stopAnimation(animation,target);
}



//Stop animation(animation.css) after 1 sec 
function stopAnimation(animation, target) {
	setTimeout(function(){
		target.removeClass("animated");
		target.removeClass(animation);
		$(document.body).css({"overflow-x":""});
	},delayInMilliseconds); //rubberBand animation	

}
