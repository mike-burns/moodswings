$.fn.element_location = function() {
  var curleft = 0;
  var curtop  = 0;
  var obj     = this;
  
  do {
	curleft += obj.attr('offsetLeft');
	curtop += obj.attr('offsetTop');
	
	obj = obj.offsetParent();
  } while ( obj.attr('tagName') != 'BODY' );
  
  return ( {x:curleft, y:curtop} );
};

$.fn.offset_within_element = function( event ) {
  var obj  = this;
  var offset = obj.element_location();
  
  return ( { 
    x: ( event.pageX - offset.x ), 
    y: ( event.pageY - offset.y ) } );
};

$.fn.FeelingWheel = function( corner_coordinates, form ) {
  var obj  = this;
  var RGBs = {
    purple:  { red: 128, green: 0,   blue: 128 },
    red:     { red: 255, green: 0,   blue: 0 },
    orange:  { red: 255, green: 165, blue: 0 },
    blue:    { red: 0,   green: 0,   blue: 255 },
    green:   { red: 0,   green: 192, blue: 0 },
    yellow:  { red: 255, green: 255, blue: 0 }
  };
  
  var in_triangle = function(coords, corners) {
    var corner_a = corners[0];
    var corner_b = corners[1];
    var corner_c = corners[2];

    return (
      aboveness(coords, corner_a, corner_b) * 
      aboveness(coords, corner_b, corner_c) > 0 && 
      aboveness(coords, corner_b, corner_c) * 
      aboveness(coords, corner_c, corner_a) > 0
    )
  };

  // a & b: endpoints of the line
  var aboveness = function(coords, a, b) {
    return (
      ( coords.y - a[1] ) *
      ( b[0]     - a[0] ) -
      ( coords.x - a[0] ) *
      ( b[1]     - a[1] )
    )
  }
  
  obj.click(function( event ) {
    var coords = $(event.target).offset_within_element( event );

    $.each( corner_coordinates,
      function( color, corners ) {
        if (in_triangle( coords, corners )){
          $("#mood_red").val( RGBs[color].red );
          $("#mood_green").val( RGBs[color].green );
          $("#mood_blue").val( RGBs[color].blue );
          
          form.submit();
        }
    });
  });
};

var triangles = {
  purple: [ [1, 129],   [77, 5],    [150, 129] ],
  red:    [ [77, 5],    [150, 129], [222, 5] ],
  orange: [ [150, 129], [222, 5],   [297, 129] ],
  blue:   [ [1, 129],   [77, 257],  [150, 129] ],
  green:  [ [77, 257],  [150, 129], [222, 257] ],
  yellow: [ [150, 129], [222, 257], [297, 129] ]
};

$(function() {
  $("#hexagon").FeelingWheel( triangles, $("#picker form") );
});