
rw = {}
rw.funcs = 
  read_write_able: (args...) ->
    @read_able(args...)
    @write_able(args...)
    
  rw_data: () ->
    @__d ?= {}

  read_able: (args...) ->
    target = this.prototype or this
    for prop in args
      target[prop] = () ->
        @rw_data()[arguments.callee.rw_name]
      target[prop].rw_name = prop
      
  write_able:  (args...) ->
    target = this.prototype or this
    for prop in args
      target.write_ables ?= []
      target.write_ables.push prop
    
  write_able_bool: (args...) ->
    @write_able(args...)

  read_write_able_bool: (args...) ->
    @read_able(args...)
    @write_able(args...)
    target = this.prototype or this
    for b in args
      target[b] = (val) ->
        switch arguments.length
          when 0
            not not @rw_data()[this.rw_name]
          when 1
            @rw_data()[this.rw_name] = (not not val)
          else
            throw new Error("Unknown arguments: #{arguments.join(', ')}")
      target[b].rw_name = b

  write: (prop, val) ->
    if !(prop in this['write_ables'])
      throw new Error("#{prop} is not write_able.")
    @rw_data()[prop] = val
    
rw.on_prototype = ["write", "rw_data"]
rw.on_this = ["read_able", "write_able", "read_write_able", "read_able_bool", "read_write_able_bool"]
    
exports.ize = (klass) ->
  me = arguments.callee
  return null if me.read_able

  proto = klass.prototype or klass
  
  for m in rw.on_prototype
    proto[m] = rw.funcs[m]
    
  for m in rw.on_this
    klass[m] = rw.funcs[m]
