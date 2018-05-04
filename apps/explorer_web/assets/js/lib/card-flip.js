import $ from 'jquery'

$('.rotatecard').click(function(){
  $(this).parents(".front").toggleClass("flipped")
<<<<<<< HEAD
  $(this).parentsUntil(".panel").next(".back").toggleClass("backflip")
=======
  $(this).parentsUntil(".theme__ribbon").next(".back").toggleClass("backflip")
>>>>>>> New theming ribbon w Social Medial links and flipping action
})

$('.rotatecardback').click(function(){
  $(this).parentsUntil(".panel").prev(".front").toggleClass("flipped")
  $(this).parents(".back").toggleClass("backflip")
<<<<<<< HEAD
})
=======
})
>>>>>>> New theming ribbon w Social Medial links and flipping action
