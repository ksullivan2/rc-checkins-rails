// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(function(){
	$(".group__topic__edit-button").click(function(){
		var id = this.id[this.id.length-1]
		var topicID = "#group__topic" + id
		var topicChangeID = "#group__topic-change" + id

		$(topicID).hide()
		$(topicChangeID).show()
	})

	$(".group__topic-change__cancel-button").click(function(){
		var id = this.id[this.id.length-1]
		var topicID = "#group__topic" + id
		var topicChangeID = "#group__topic-change" + id

		$(topicID).show()
		$(topicChangeID).hide()
	})
})

