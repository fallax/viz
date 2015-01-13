Array.prototype.first = (predicate) -> (return item) for item in this when predicate item; null;
Array.prototype.max = () -> this.reduce ((t, s) -> Math.max t, s), this[0]
Array.prototype.min = () -> this.reduce ((t, s) -> Math.min t, s), this[0]
Array.prototype.sum = () -> this.reduce ((t, s) -> t + s), 0
Array.prototype.range = () -> [this.min(), this.max()]

# nasty quick way of getting appropriate quant axis labels
labels = (range) ->
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

scale = (range, interval) ->
  zoom = (interval[1] - interval[0]) / (range[1] - range[0])
  offset = interval[0]
  return (input) -> ((input - range[0]) * zoom) + offset

window.axis = (datapoints, key, outputrange) ->
	range = (datapoint[key] for datapoint in datapoints).range()
	axis =
		range: range
		labels: labels(range)
		scale: scale(range, outputrange)
	axis