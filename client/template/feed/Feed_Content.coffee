Template.Feed_Content.rendered = ->
  $('.modal-trigger').leanModal()
  return

Template.Feed_Content.events = 'click #feed-reply-cancel': ->
  $('#modal2').closeModal();
  return