$(document).on('touchstart', tstart);
$(document).on('touchmove', tmove);
$(document).on('touchend', tend);
$(window).on('ondevicemotion', dmotion);





var o = false;

$(window).on('devicemotion', dmotion);


function dmotion(e) {
    var x = e.originalEvent.accelerationIncludingGravity.x;
    var y = e.originalEvent.accelerationIncludingGravity.y;
    var z = e.originalEvent.accelerationIncludingGravity.z;

    if (!o)
    o = e;


    $('.x span').text(Math.round(x));
    $('.y span').text(Math.round(y));
    $('.z span').text(Math.round(z));

//    $('.x span').text(e.originalEvent.accelerationIncludingGravity.x);
//    $('.y span').text(e.originalEvent.accelerationIncludingGravity.y);
//    $('.z span').text(e.originalEvent.accelerationIncludingGravity.z);


}




function tstart(e) {
}

function tmove(e) {
    e.preventDefault()
}
function tend(e) {
}



