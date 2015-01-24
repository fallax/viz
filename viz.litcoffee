Some helper functions to help handling arrays nicely.

    Array.prototype.first = (predicate) -> (return item) for item in this when predicate item; null;
    Array.prototype.max = () -> this.reduce ((t, s) -> Math.max t, s), this[0]
    Array.prototype.min = () -> this.reduce ((t, s) -> Math.min t, s), this[0]
    Array.prototype.sum = () -> this.reduce ((t, s) -> t + s), 0
    Array.prototype.range = () -> [this.min(), this.max()]
    Array.prototype.contains = (element) -> (return true) for item in this when item is element; false;

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

    window.quantscale = (range, interval) ->
      zoom = (interval[1] - interval[0]) / (range[1] - range[0])
      offset = interval[0]
      return (input) -> ((input - range[0]) * zoom) + offset

    window.qualscale = (range, interval, keys) ->
      scale = window.quantscale range, interval
      return (input) -> scale keys.indexOf(input)

    window.axis = (datapoints, key, outputrange) ->

      console.log "Proceessing key " + key

      values = (datapoint[key] for datapoint in datapoints).slice()

      typeGuess = findType values

      values = parse values, typeGuess 
      
      axis = 
        datatype: typeGuess
        values: values

      switch typeGuess
        when "number"
          axis.range = values.range()
          axis.labels = labels(axis.range)
          axis.scale = quantscale(axis.range, outputrange)
        when "string"
          keys = axis.values.unique()
          axis.range = [0, keys.length]
          axis.scale = qualscale(axis.range, outputrange, keys)
      axis