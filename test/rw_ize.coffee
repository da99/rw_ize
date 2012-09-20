rw = require "rw_ize"
assert = require "assert"

describe "rw_ize", () ->

  describe "read_or_write(k, v)", () ->
    
    it "sets value of key", () ->
      obj = {}
      rw.ize(obj)
      obj.read_able "name"
      obj.read_or_write("name", "ted")
      assert.equal obj.name(), "ted"
      
    it "throws error if called w/o args.", () ->
      obj = {}
      rw.ize(obj)
      obj.read_able "name"
      obj.read_or_write("name", "ted")
      err = null
      try
        obj.read_or_write()
      catch e
        err = e
      assert.deepEqual err.message, "Key not found: undefined"

    it "raise an error if trying to set an unknown key", () ->
      obj = {}
      rw.ize(obj)
      obj.read_able "name"
      err = try
        obj.read_or_write("names", "ted")
      catch e
        e
      assert.deepEqual err.message, "Key not found: names"

  describe "read_able", () ->

    it "adds a method to the prototype", () ->

      class Car
        rw.ize(this)
        @read_able "year"
        constructor: () ->
          @read_or_write 'year', "1999"

      c = new Car()
      assert.equal c.year(), "1999"

    it "adds a method to objects", () ->

      car = {}
      rw.ize(car)
      car.read_able "price"
      car.read_or_write 'price', "$10"
      assert.equal car.price(), "$10"

  describe "write_able", () ->

    it "adds a method to the prototype", () ->

      class Spaceship
        rw.ize(this)
        @write_able "location"
        constructor: () ->
          
      s = new Spaceship()
      s.location "NYC"
      assert.equal s.read_or_write('location'), "NYC"
      
      
  describe "read_write_able", () ->

    it "adds both a read and write method to the prototype", () ->

      class Unicycle
        rw.ize(this)
        @read_write_able "price"
        constructor: () ->
          @read_or_write 'price', "$7"
      u = new Unicycle()
      assert.equal u.price(), "$7"
      u.price "$8"
      assert.equal u.price(), "$8"
      
  describe "read_able_bool", () ->

    it "adds a read method to the prototype", () ->

      class Truck
        rw.ize(this)
        @read_able_bool "on"
        constructor: () ->

      t = new Truck()
      assert.equal t.on(), false

    it "reads from manually set value", () ->

      class Truck
        rw.ize(this)
        @read_able_bool "on"
        constructor: () ->
          @read_or_write "on", true

      t = new Truck()
      assert.equal t.on(), true


  describe "read_write_able_bool", () ->

    it "adds both a read and write method to the prototype", () ->

      class Switch
        rw.ize(this)
        @read_write_able_bool "on"
        constructor: () ->
      
      s = new Switch()
      assert.equal s.on(), false
      s.on(true)
      assert.equal s.on(), true
      
      
    it "adds both a read and write method to the object", () ->
      ship = {}
      rw.ize(ship)
      ship.read_write_able_bool "afloat"
      assert.equal ship.afloat(), false
      ship.afloat(true)
      assert.equal ship.afloat(), true
      
    it "adds a seperate read/write method for each different bool", () ->
      ship = {}
      rw.ize(ship)
      ship.read_write_able_bool "afloat"
      ship.read_write_able_bool "sinking"
      
      ship.afloat(true)
      assert.equal ship.afloat(), true
      assert.equal ship.sinking(), false
      
    it "reads from manually set value", () ->

      class Sailboat
        rw.ize(this)
        @read_write_able_bool "engine_on"
        constructor: () ->
          @read_or_write "engine_on", true

      t = new Sailboat()
      assert.equal t.engine_on(), true


  describe "private_ize", () -> 

    it "throws an error if read method is used as a writer", () ->
      ship = {}
      rw.ize(ship)
      ship.private_ize "color"
      ship.read_able "color"
      try 
        ship.color "red"
      catch e
        err = e
      assert.equal err.message, "Key is not write_able: color"

