# namespace function from the coffeescript faq
namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top


namespace 'App', (exports) ->
  class exports.Netwalk
    constructor: (options = {}) ->
      defaults =
        containerSelector: '#netwalk'
        rows: null
        columns: null
        size: 40
      @options = _.extend defaults, options
    
      self = @
      @Dir =
        up: Vector.create [0, -1] # bit flag 1 (decimal) 0001 (binary)
        down: Vector.create [0, 1] # bit flag 2 (decimal) 0010 (binary)
        left: Vector.create [-1, 0] # bit flag 4 (decimal) 0100 (binary)
        right: Vector.create [1, 0] # bit flag 8 (decimal) 1000 (binary)
        
      # Populate direction Vectors with bitwise maps
      @Dir.up.flag = @Dir.down.opposite = 1 # 0001 in binary
      @Dir.up.opposite = @Dir.down.flag = 2 # 0010 in binary
      @Dir.left.flag = @Dir.right.opposite = 4 # 0100 in binary
      @Dir.left.opposite = @Dir.right.flag = 8 # 1000 in binary
        
      # Arrays of figures sorted by type
      @figures =
        computer: [1,8,2,4]
        server: [17,24,18,20]
        elbow: [9,10,6,5]
        line: [3,12]
        tee: [13,11,14,7]
        
      @container = $(@options.containerSelector)
      
      # Reset container view
      @container.html('')
      @container.css('max-width', 'none')
      @container.css('max-height', 'none')
      
      if not @options.size? and not @options.columns?
        log 'at least size or # of columns required'
        return
      
      # Update view with font-size and max width/height
      if not @options.size?
        @options.size = @container.width() / @options.columns
        
      if not @options.columns?
        @options.columns = Math.round @container.width() / @options.size
        
      if not @options.rows?
        @options.rows = Math.round @container.height() / @options.size
        
      @container.css('font-size', Math.round(@options.size/10 - 1) * 10 )
      @container.css('max-width', "#{@options.columns}em")
      @container.css('max-height', "#{@options.rows}em")
      
      # Represents whether drawing is finished or not
      @drawingIsDone = false
      
      # Build the board matrix
      self.buildMatrix()
      # Put Server node on the board
      @serverVector = Vector.create [1 + _.random(@options.columns - 2), 1 + _.random(@options.rows - 2)]
      @.putOnBoard(@serverVector, 16)
      # Draw
      drawTicks = setInterval (->
        unless self.tick()
          clearInterval drawTicks
          @drawingIsDone = true
      ), 5
      # Shuffle pieces direction
      randomizeTicks = setInterval (->
        return unless @drawingIsDone
        unless self.randomize()
          clearInterval randomizeTicks
          self.highlightConnectedNeighboursOf self.serverVector
      ), 5

      # Prevent from selecting
      @container.on('selectstart', false)
      # Rotate when clicked
                .children().each (i, tail) ->
                  $(tail).on 'click', (event) ->
                    self.rotate i
                    # Unhighlight all cells
                    $('>', self.container).each ->
                      $(this).attr('class', 'tail')
                    
                    # Reset array of connected cells
                    self.connectedCells = []
                    # Highlight connected cells
                    self.highlightConnectedNeighboursOf self.serverVector
    
    rotate: (cell) ->
      figure = @board[cell]
      figure = @.turnFigure figure
      # Update main Collection with new figure
      @board[cell] = figure
      # Update UI
      className = @.getClassNameByMask figure
      @.style cell, className
      
    highlightConnectedNeighboursOf: (vector, exceptDirection = null) ->
      
      cell = @.getCellByVector vector
      figure = @board[cell]
      type = @.typeOfFigure figure
      
      # No need to connect anything twice
      if _.indexOf(@connectedCells, cell) != -1
        log "cell #{cell} is already connected"
        return
      
      # If computer - connect it and return
      if type == 'computer'
        # Add this cell to the list of connected ones
        # in order to avoid checking same cell more than once
        @connectedCells.push neighbourCell
        
        # Update UI
        $('>', @container).each (i,j) ->
          if i == cell
            $(this).attr('class', 'tail--connected')
        return
      
      # If not computer - traverse further..
      for d of @Dir
        if figure & @Dir[d].flag
          neighbourVector = vector.add @Dir[d]
          
          # Usually this is to prevent going back to the cell from which we came which would result in endless loop
          if @Dir[d].flag is exceptDirection
            continue
          
          # prevent from going out of board
          unless @.inBounds neighbourVector
            continue
          
          neighbourCell = @.getCellByVector neighbourVector
          neighbourFigure = @board[neighbourCell]
          if neighbourFigure & @Dir[d].opposite
            # Continue the search of connected cells
            @.highlightConnectedNeighboursOf neighbourVector, @Dir[d].opposite
        
    getCellByVector: (v) ->
      v.elements[0] + v.elements[1] * @options.columns
      
    getVectorByCell: (cell) ->
      y = (cell - cell % @options.columns) / @options.columns
      x = cell - @options.columns * y
      Vector.create [x,y]
      
    getClassNameByMask: (mask) ->
      className = 'tail__'
      if mask == 0
        className += 'blank'
      # Server
      else if mask & 16 || mask & 32
        if mask & 1
          className += 'server--top'
        else if mask & 2
          className += 'server--bottom'
        else if mask & 4
          className += 'server--left'
        else if mask & 8
          className += 'server--right'
        else
          className += 'server'
      # Computer TOP
      else if mask == 1
        className += 'computer--top'
      # Computer BOTTOM
      else if mask == 2
        className += 'computer--bottom'
      # Computer LEFT
      else if mask == 4
        className += 'computer--left'
      # Computer RIGHT
      else if mask == 8
        className += 'computer--right'
      # Line Vertical
      else if mask == 3
        className += 'line--vertical'
      # Line Horizontal
      else if mask == 12
        className += 'line--horizontal'
      # Elbow Top Right
      else if mask == 9
        className += 'elbow--topright'
      # Elbow Right Bottom
      else if mask == 10
        className += 'elbow--rightbottom'
      else if mask == 6
        className += 'elbow--bottomleft'
      else if mask == 5
        className += 'elbow--lefttop'
      else if mask == 13
        className += 'tee--top'
      else if mask == 11
        className += 'tee--right'
      else if mask == 14
        className += 'tee--bottom'
      else if mask == 7
        className += 'tee--left'
      else
        className = ''
      className
      
    # Returns number of cables 
    numOfCables: (cell) ->
      cablesMap = @board[cell]
      count = 0
      for d of @Dir
        ++count if cablesMap & @Dir[d].flag
      count
      
    typeOfFigure: (figure) ->
      # figure is BIT representation of cables a cell may have, for example a VERTICAL line would have a value of 1(top) + 2(bottom) = 3, a HORIZONTAL line would be 4(left) + 8(right) = 12 and so on..
      for type of @figures
        unless _.indexOf(@figures[type], figure) is -1
          return type
      return null
      
    # Turn clockwise once
    turnFigure: (figure) ->
      type = @.typeOfFigure figure
      if type?
        figures = @figures[type]
        figureIndex = _.indexOf(figures, figure)
        newFigureIndex = if ++figureIndex < figures.length then figureIndex else 0
        newFigure = figures[newFigureIndex]
        #log "Turn figure #{figure} to #{newFigure}"
      else
        log "OOPS unknown type for figure #{figure}"
      # return new figure
      newFigure
        
      
    randomFreeDir: (cell) ->
      map = @neighbours[cell]
      figure = @board[cell]
      numOfCables = @.numOfCables cell
      
      # SERVER should only have 1 Cable
      return null if figure & 16 and numOfCables > 0
      # Allow up to 3 cables per each cell
      return null if numOfCables == 3    
      
      i = _.random(@.directionsInMap(map))
      for d of @Dir
        #return @Dir[d] if figure & 16 and figure & @Dir[d].flag
        return @Dir[d] if map & @Dir[d].flag && i-- == 0
      return null
      
    # map contains directions
    directionsInMap: (neighboursMap) ->
      count = 0
      for d of @Dir
        if neighboursMap & @Dir[d].flag
          ++count
      count;
      
    inBounds: (vector) ->
      x = vector.elements[0]
      y = vector.elements[1]
      x >= 0 && y >= 0 && x < @options.columns && y < @options.rows
      
    putOnBoard: (vector, directionBit) ->
      cell = @.getCellByVector vector
      
      # Never visited: add to visit list and to randomize list
      if @board[cell] is 0
        @toDraw.push vector 
        @toRandomize.push vector

      # Make cell be wired with specified direction
      @board[cell] |= directionBit
      
      for d of @Dir
        nvector = vector.add @Dir[d]
        ncell = @.getCellByVector nvector
        # Add cell to the list of neighbors for it's neighbors
        @neighbours[ncell] &= ~@Dir[d].opposite if @.inBounds nvector
      
    buildMatrix: ->
      @board = [0...@options.columns * @options.rows]
      @neighbours = [0...@options.columns * @options.rows]
      @toDraw = []
      @toRandomize = []
      @connectedCells = []
      
      # Save neighbours information for EVERY cell
      # At this point we already know ALL neighbours
      for i in [0...@options.columns]
        for j in [0...@options.rows]
          vector = Vector.create [i, j]
          cell = @.getCellByVector(vector)
          @board[cell] = 0
          @neighbours[cell] = 0
          for d of @Dir
            nvector = vector.add @Dir[d]
            @neighbours[cell] |= @Dir[d].flag if @.inBounds(nvector)
                  
      for cell in [0...@options.columns * @options.rows]
        @container.append('<div class="tail"><div class="tail__blank"></div></div>')
      
    style: (cell, className) ->
      unless className is ''
        # cells in matrix are ZERO based while DOM elements start with 1
        cell++
        $tail = $(":nth-child(#{cell})", @container)
        $node = $(':first-child', $tail)
        $node.attr('class', className)
      
    draw: ->
      for i in [0...@options.columns]
        for j in [0...@options.rows]
          cell = @.getCellByVector(Vector.create([i, j]))
          @.style cell, @.getClassNameByMask(@board[cell])
          
    tick: ->
      return false if @toDraw.length == 0
      madeConnection = false
      @.draw()
      while not madeConnection and @toDraw.length > 0
        
        # Pick a random cell to visit.
        i = _.random @toDraw.length-1
        vector = @toDraw[i]
        cell = @.getCellByVector vector
      
        # Pick a random free direction, if one exists.
        d = @.randomFreeDir(cell)
        if d
        
          # Add a connection in that direction.
          @.putOnBoard vector, d.flag
          @.putOnBoard vector.add(d), d.opposite
          madeConnection = true
      
        # Remove cell from to-visit list if all neighbours filled.
        @toDraw.splice i, 1  if (@neighbours[cell] & 15) is 0
          
    randomize: ->
      return false if @toRandomize.length == 0
      # Pick a random cell to randomize
      i = _.random @toRandomize.length-1
      vector = @toRandomize[i]
      cell = @.getCellByVector vector
      figure = @board[cell]
      
      # Turn figure n times
      # 0 - it will not turn at all
      # 1 - once, 2 - twice, 3 - three times
      j = _.random 3
      while j
        figure = @.turnFigure figure
        --j
        
      # Update main Collection with new figure
      @board[cell] = figure
      
      # Update UI
      className = @.getClassNameByMask figure
      @.style cell, className
      
      # Delete cell from list of cells to randomize
      @toRandomize.splice i, 1
