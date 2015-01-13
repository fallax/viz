Array.prototype.first = (predicate) -> (return item) for item in this when predicate item; null;
Array.prototype.max = () -> this.reduce ((t, s) -> Math.max t, s), this[0]
Array.prototype.min = () -> this.reduce ((t, s) -> Math.min t, s), this[0]
Array.prototype.sum = () -> this.reduce ((t, s) -> t + s), 0
Array.prototype.range = () -> [this.min(), this.max()]