Some helper functions to help handling arrays nicely.

    Array.prototype.first = (predicate) -> (return item) for item in this when predicate item; null;
    Array.prototype.max = () -> this.reduce ((t, s) -> Math.max t, s), this[0]
    Array.prototype.min = () -> this.reduce ((t, s) -> Math.min t, s), this[0]
    Array.prototype.sum = () -> this.reduce ((t, s) -> t + s), 0
    Array.prototype.range = () -> [this.min(), this.max()]

A function which given a numeric range, returns appropriate ticks to put on an axis representing that quantity. For the moment, using a horrible quick dodgy implementation. In future, we should use Talbot's algorithm for this: http://www.justintalbot.com/research/axis-labeling/ - we can base this code on the Closure implmentation at https://keminglabs.com/c2/docs/#c2.ticks

    window.labels = (range) ->
      # get a rough estimate of an appropriate tick size
      ticksize = Math.pow(10, Math.floor(Math.log(range[1]-range[0])/Math.log(10))) 

      # fiddle around with the tick size until it comes out roughly right (5-9 ticks)
      ticks = Math.floor(range[1] / ticksize) - Math.ceil(range[0] / ticksize)
      if ticks < 2 then ticksize = ticksize / 10
      ticks = Math.floor(range[1] / ticksize) - Math.ceil(range[0] / ticksize)
      if ticks > 9 then ticksize = ticksize * 2
      ticks = Math.floor(range[1] / ticksize) - Math.ceil(range[0] / ticksize)
      if ticks < 5 then ticksize = ticksize / 2

      # work out where the ticks actually are and return a list of them
      firsttick = Math.ceil(range[0] / ticksize) * ticksize
      ticks = Math.floor(range[1] / ticksize) - Math.ceil(range[0] / ticksize)
      return ((firsttick + i*ticksize) for i in [0..ticks])

    window.scale = (range, interval) ->
      zoom = (interval[1] - interval[0]) / (range[1] - range[0])
      offset = interval[0]
      return (input) -> ((input - range[0]) * zoom) + offset

    window.findType = (values) ->
      guess = "number"

      for value in values
        switch typeof value
          when "number"
            # do nuffin!
            a = 1
          when "string"
            if isNaN value then guess = "string"
          else 
            guess = "unknown"

      guess

    window.parse = (values, to) ->
      for value in values
        switch to
          when "number"
            if typeof value is "string"
              if not isNaN value then parseFloat(value) else throw "aargh!"
            else value
          else
            value

    window.axis = (datapoints, key, outputrange) ->
      values = (datapoint[key] for datapoint in datapoints).slice()

      console.log findType values

      values = parse values, "number" 

      console.log values

      range = values.range()
      axis =
        range: range
        labels: labels(range)
        scale: scale(range, outputrange)
      axis