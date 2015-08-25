moduleKeywords = ['extended', 'included']

window.Modulable =
  extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      this[key] = value

    obj.extended?.apply(this)
    this

  include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      this::[key] = value

    obj.included?.apply(this)
    this

# Create new class extended from @baseKlass and mixed with all mixins passed through arguments
window.mix = ->
  args = Array.prototype.slice.call arguments, 0
  baseKlass = args.shift()
  class Temp extends baseKlass
  _.extend(Temp, mixin) for mixin in args
  Temp

# Create new class extended from @baseKlass and mixed with Modulable
window.modulable = (baseKlass) ->
  mix baseKlass, Modulable

