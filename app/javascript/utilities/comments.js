$(document).on('turbolinks:load', function(){
    $('.add-comment').on('click', function(e){
        e.preventDefault();
        $(this).hide();
        let commentable_id = $(this).data('commentable');
        // console.log("comments.js Add comment = " + commentable_id)
        $('form#comment-form-' + commentable_id).removeClass('hidden');
    });
});
