// JavaScript Document
$(document).ready(function() {

    $('.lightbox').click(function() {
        var thisBox = $(this).attr("name");
        console.log(thisBox);
        $('.backdrop,.' + thisBox).animate({
            'opacity': '.50'
        }, 300, 'linear');
        $('.box').animate({
            'opacity': '1.00'
        }, 300, 'linear');
        $('.backdrop,.' + thisBox).css('display', 'block');
    });

    $('.close').click(function() {
        close_box();
    });

    $('.backdrop').click(function() {
        close_box();
    });
    
    function close_box() {
        $('.backdrop,.box').animate({
            'opacity': '0'
        }, 300, 'linear', function() {
            $('.backdrop,.box').css('display', 'none');
        });
    }

});