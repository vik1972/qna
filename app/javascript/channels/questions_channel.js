import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  let questionsList = $('.questions');
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
    this.perform('follow')
  },
  received(content) {
      questionsList.append(content);
    }
  });
})


