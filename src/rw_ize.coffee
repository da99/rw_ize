"use strict"

rw = {}
rw.funcs = 
  read_write_able: (args...) ->
    @read_able(args...)
    @write_able(args...)
    
  rw_keys: () ->
    @__rw_keys ?= []

  rw_data: (args...) ->
    @__d ?= {}
    if args.length is 0
      @__d
    else if args.length is 2
      k = args[0]
      v = args[1]
      if not(k in @rw_keys())
        throw new Error("Unknown key being set: #{k}")
      @__d[k] = v
    else
      throw new Error("Unknown arguments: #{args}")

  read_able: (args...) ->
    target = this.prototype or this
    for prop in args
      target.rw_keys().push prop
      target[prop] = new Function """
          return this.rw_data()["#{prop}"];  
      """
      
  write_able:  (args...) ->
    target = this.prototype or this
    for prop in args
      target.write_ables ?= []
      target.write_ables.push prop
    
  read_able_bool: (args...) ->
    @read_able(args...)
    target = this.prototype or this
    for b in args
      target[b] = new Function """
          return !!this.rw_data()["#{b}"];
      """
    
    
  write_able_bool: (args...) ->
    @write_able(args...)
    target = this.prototype or this
    for b in args
      target[b] = new Function 'val', """
      
        var prop = "#{b}";
        var data = this.rw_data();
        var final = null;

        switch( arguments.length ) {
          case 0:
            final = !!data[prop];
            break;
          case 1:
            final = ( data[prop] = !!val);
            break;
          default:
            throw new Error("Unknown arguments: " + arguments.join(', '));
        };
        return final;
      """

  read_write_able_bool: (args...) ->
    @read_able_bool(args...)
    @write_able_bool(args...)

  write: (prop, val) ->
    if !(prop in this['write_ables'])
      throw new Error("#{prop} is not write_able.")
    @rw_data()[prop] = val
    
rw.on_prototype = ["write", "rw_keys", "rw_data"]
rw.on_this = ["read_able", "write_able", "read_write_able", "read_able_bool", "write_able_bool", "read_write_able_bool"]
    
exports.ize = (klass) ->
  return null if klass.read_able

  proto = klass.prototype or klass
  
  for m in rw.on_prototype
    proto[m] = rw.funcs[m]
    
  for m in rw.on_this
    klass[m] = rw.funcs[m]
    
    
    
    
