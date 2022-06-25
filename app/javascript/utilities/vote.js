$(document).on('turbolinks:load', function(){
    $('.vote').on('ajax:success', function(e){
        let rating = e.detail[0]['rating'],
            resourceName = e.detail[0]['resourceName'],
            resourceId = e.detail[0]['resourceId'];

        $('#' + resourceName + '-' +resourceId + ' .vote .rating').html(rating)
    })
})