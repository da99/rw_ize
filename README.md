
rw\_ize
======

Add readable and writable properties to your "classes" and objects.


Install and Use It
======

In your shell:

    npm install rw_ize

In your coffeescript:

    rw = require "rw_ize"

    class Pancake

       rw.ize(this)
       @read_able       "size"
       @write_able      "location"
       @read_write_able "name"
       @read_write_able_bool "for_sale"

       constructor(name):
         @write "size", "3.5 inches"
         @write "name", name

    cake = new Pancake("Bob")
    cake.size()  # --> "3.5 inches"
    cake.location "NYC"
    cake.name()  "Billy Bob"
    cake.for_sale()  # --> false
    cake.for_sale(true)
    cake.for_sale() # --> true

You can also use it directly on objects:

    car = {}
    rw.ize(car)
    car.read_write_able "price"
    car.price   "$3,000"
    car.price()  # ---> "$3,000"

    
