$(document).on('turbolinks:load', function(){
    $('.add-comment').on('click', function(e){
        e.preventDefault();
        $(this).hide();
        let commentable = $(this).data('commentable');
        // console.log("comments.js Add comment = " + commentable)
        $('form#comment-form-' + commentable).removeClass('hidden');
    });
});
