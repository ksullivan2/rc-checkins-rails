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
})

$(function(){
	$(".group__topic-change__cancel-button").click(function(){
		var id = this.id[this.id.length-1]
		var topicID = "#group__topic" + id
		var topicChangeID = "#group__topic-change" + id

		$(topicID).show()
		$(topicChangeID).hide()
	})
})






// <div class="group__topic" id="group__topic<%=group.id%>">
// 		<p>Topic: <%= group.topic %>
// 			<%= link_to image_tag("edit.png"), {:controller => "groups", :action => "toggle_edit", :id => "group__topic__edit-button" + group.id.to_s}, {:method => "post"} %>
// 		</p>
// 	</div>

// 	<div class="group__topic-change" id="group__topic-change<%=group.id%>">
// 		<p>New Topic:
// 			<%= form_for :group, url: group_path(group), method: :patch do |f| %>
// 				<p><%= f.text_field :topic %></p>
// 			  <p><%= f.submit :value => "change topic", :id=> "group__topic-change__submit-button"+ group.id.to_s %></p>
// 		  <% end %>
// 		</p>
// 	</div>