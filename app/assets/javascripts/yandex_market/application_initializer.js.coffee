@JodyNotificator.clean = ->
  Notifications.clean()

@JodyNotificator.error = (error) ->
  Notifications.show_error(error)

@JodyNotificator.errors = (errors) ->
  Notifications.show_errors(errors)

@JodyNotificator.flashs = (flashs) ->
  Notifications.show_flash(flashs)

@JodyNotificator.flash = (method, _msg) ->
  flashs = {}
  flashs[ method ] = _msg
  Notifications.show_flash(flashs)

$ ->
  ElcoForm.init()
  Notifications.init()
  MarketCheckbox.init()