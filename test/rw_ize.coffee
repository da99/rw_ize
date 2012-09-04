rw = require "rw_ize"
assert = require "assert"

describe "rw_ize", () ->

  describe "rw_data(k, v)", () ->
    
    it "sets value of key", () ->
      obj = {}
      rw.ize(obj)
      obj.read_able "name"
      obj.rw_data("name", "ted")
      assert.equal obj.name(), "ted"
      
    it "returns obj if called w/o args.", () ->
      obj = {}
      rw.ize(obj)
      obj.read_able "name"
      obj.rw_data("name", "ted")
      assert.deepEqual obj.rw_data(), { name: "ted" }

    it "raise an error if trying to set an unknown key", () ->
      obj = {}
      rw.ize(obj)
      obj.read_able "name"
      err = try
        obj.rw_data("names", "ted")
      catch e
        e
      assert.deepEqual err.message, "Unknown key being set: names"

  describe "read_able", () ->

    it "adds a method to the prototype", () ->

      class Car
        rw.ize(this)
        @read_able "year"
        constructor: () ->
          @rw_data().year = "1999"

      c = new Car()
      assert.equal c.year(), "1999"

    it "adds a method to objects", () ->

      car = {}
      rw.ize(car)
      car.read_able "price"
      car.rw_data().price = "$10"
      assert.equal car.price(), "$10"

  describe "write_able", () ->

    it "adds a method to the prototype", () ->

      class Spaceship
        rw.ize(this)
        @write_able "location"
        constructor: () ->
          
      s = new Spaceship()
      s.write "location", "NYC"
      assert.equal s.rw_data().location, "NYC"
      
      
  describe "read_write_able", () ->

    it "adds both a read and write method to the prototype", () ->

      class Unicycle
        rw.ize(this)
        @read_write_able "price"
        constructor: () ->
          @rw_data().price = "$7"
      u = new Unicycle()
      assert.equal u.price(), "$7"
      u.write "price", "$8"
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
          @rw_data "on", true

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
          @rw_data "engine_on", true

      t = new Sailboat()
      assert.equal t.engine_on(), true


