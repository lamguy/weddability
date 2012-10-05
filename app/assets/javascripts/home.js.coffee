# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  # Preload the images
  images = ["/assets/comingsoon.jpg"]
  
  # A little script for preloading all of the images
  # It"s not necessary, but generally a good idea
  $(images).each ->
    $("<img/>")[0].src = this

  $.backstretch images[0]
