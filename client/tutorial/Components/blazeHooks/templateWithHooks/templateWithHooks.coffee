Template.templateWithHooks.viewmodel
  onCreated: -> console.log "templateWithHooks - onCreated"
  onRendered: -> console.log "templateWithHooks - onRendered"
  onDestroyed: -> console.log "templateWithHooks - onDestroyed"
  blaze_helpers:
    text: "Blaze Button"
  blaze_events:
    'click button': -> console.log "templateWithHooks - click"