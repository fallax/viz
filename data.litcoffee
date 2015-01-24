# Data methods

Some methods for handling objects whose data types may not be known, where values might be missing, etc.

    window.findType = (values) ->
      guess = "number"

      for value in values
        if value?
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
            if not value?
              0
            else 
              if typeof value is "string"
                if not isNaN value then parseFloat(value) else throw "aargh!"
              else value
          else
            if not value?
              "(no value)"
            else 
              value

    window.getKeys = (values) ->
      result = {};

      for value in values
        for key in Object.keys(value)
          if result[key] then result[key]++ else result[key] = 1
      return result

(from https://coffeescript-cookbook.github.io/chapters/arrays/removing-duplicate-elements-from-arrays)

    Array::unique = ->
      output = {}
      output[@[key]] = @[key] for key in [0...@length]
      value for key, value of output

