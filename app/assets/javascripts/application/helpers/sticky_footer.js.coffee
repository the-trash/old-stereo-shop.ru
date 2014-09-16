stickFooter = () ->
  $('body').css('margin-bottom', $('footer').height())

didResize = false

stickFooter()

$(window).resize ->
  didResize = true

setInterval ->
  if didResize
    didResize = false
    stickFooter()
, 250