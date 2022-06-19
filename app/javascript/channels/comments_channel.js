import consumer from "./consumer"
// import template from "./templates/answers.hbs";
$(document).on('turbolinks:load', function () {
  if (/questions\/\d+/.test(window.location.pathname)) {
    let commentsList = $('.comments');
    let template = require('./templates/comments.hbs')
    consumer.subscriptions.create({channel: "CommentsChannel", question_id: gon.question_id}, {
      received(data) {
        if (gon.current_user_id === data.comment.user_id) return;
        commentsList.append(template(data));
      }
    });
  }
});


// consumer.subscriptions.create("CommentsChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//   },
//
//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },
//
//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//   }
// });
