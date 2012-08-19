rw = require "rw_ize"
assert = require "assert"

describe "rw_ize", () ->

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
      

