$(document).on('turbolinks:load', function(){
    $('.add-comment').on('click', function(e){
        e.preventDefault();
        $(this).hide();
        let questionId = $(this).data('questionId');
        console.log(questionId )
        $('form#question-' + questionId + '-comments').removeClass('hidden');
    });
});