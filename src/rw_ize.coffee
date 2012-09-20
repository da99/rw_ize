"use strict"

class RW_Key

  @reader_code: (prop) -> 
    """
      if ( arguments.length == 0 )
        this.throw_unless_rw( '#{prop}', 'read' );
      else
        this.throw_unless_rw( '#{prop}', 'write' );
      return this.read_or_write.apply( this, ["#{prop}"].concat( Array.prototype.slice.call(arguments) ) );
    """
  constructor: (n) ->
    @_name_          = n
    @_is_read_able   = false
    @_is_write_able  = false
    @_is_bool_       = false

  name: () ->
    @_name_
    
  for v in [ 'read_able', 'write_able', 'bool' ]
    this.prototype["is_#{v}"] = new Function """
      if (arguments.length === 1 ) {
        this._is_#{v}_ = !!(arguments[0]);
      };
      return this._is_#{v}_;
    """
  is_read_write_able: () ->
    @is_read_able() and @is_write_able()

  is_public: () ->
    @is_read_write_able()

  is_private: ( ) ->
    not @is_read_write_able()

    
rw = {}

# ==============================================================
#                    Class DSL
# ==============================================================

rw.class_dsl = 

  rw_get_set: (type, n, val) ->
    target = this.prototype or this
    
    switch type
      
      when 'key'
        keys = target.rw_keys()
        k = keys[n]
        if not k
          k = keys[n] = new RW_Key(n)
        k
        
      when 'func'
        target[n] = val

      else 
        throw new Error "Unknown value: #{type}"

  private_ize: (args...) ->
    for prop in args
      k = @rw_get_set( 'key', prop )
      k.is_read_able false
      k.is_write_able false
      
  read_write_able: (args...) ->
    @read_able(args...)
    @write_able(args...)
    
  read_able: (args...) ->
    for prop in args
      @rw_get_set('key', prop).is_read_able(true)
      @rw_get_set 'func', prop, new Function RW_Key.reader_code(prop)
    
  write_able:  (args...) ->
    for prop in args
      @rw_get_set( 'key', prop ).is_write_able(true)
      @rw_get_set 'func', prop, new Function RW_Key.reader_code(prop)
    
  read_able_bool: (args...) ->
    @read_able args...
    for b in args
      k = @rw_get_set('key', b )
      k.is_bool(true)
    
  write_able_bool: (args...) ->
    @write_able(args...)
    for b in args
      k = @rw_get_set 'key', b
      k.is_bool(true)

  read_write_able_bool: (args...) ->
    @read_able_bool(args...)
    @write_able_bool(args...)

rw.instance_dsl = 

  # ==============================================================
  #                      Inspection
  # ==============================================================
  
  rw_key: (n) ->
    @rw_keys()[n]

  rw_keys: (n) ->
    @_rw_keys_ ?= {}

  # ==============================================================
  #                      RW Keys
  # ==============================================================
      
  throw_unless_rw: (name, action) ->
    key = @rw_key name
    if not key["is_#{action}_able"]()
      throw new Error "Key is not #{action}_able: #{name}"
    true
    
  read_or_write: (args...) ->
    @_rw_data_ ?= {}
    d = @_rw_data_
    
    key_name = args[0]
    value    = args[1]
    key = @rw_key key_name
    
    if not key
      throw new Error "Key not found: #{key_name}"
    
    switch args.length
      when 2 # name, val => WRITE
        if key.is_bool()
          value = not not value
        d[key.name()] = value

      when 1 # name => READ
        value = d[key.name()] 
        if key.is_bool()
          not not value
        else
          value

      else
        throw new Error "Unknown arguments: #{(v for v in args)}"
      
      

    
exports.ize = (obj) ->
  if obj.read_able
    throw new Error "Object has alread been rw_iz'ed."
  if (not obj.prototype) and obj.constructor.read_able
    throw new Error "Unable to add to an instance with a prototype already rw_iz'ed." 

  proto = obj.prototype or obj
  
  for name, func of rw.instance_dsl
    proto[name] = func
    
  for name, func of rw.class_dsl
    obj[name] = func
    
exports.ize.RW_Key = RW_Key
    
    
    
