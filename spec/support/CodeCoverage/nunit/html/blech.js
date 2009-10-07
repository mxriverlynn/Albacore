/*
 * blech.js
 * A graphing library for javascript, by Alan Johnson, Gnoso.
 * Because nobody likes graphing, but everybody has to do it.
 */
 
/*
 * Base class for graphs.
 */
var GraphBase = Class.create({
  /* 
   * Takes the element that should be used for the graph as an argument. 
   * Takes a set of options as the second parameter.
   *
   * Available Options:
   * TODO: Scaling
   * TODO: Image for points
   * TODO: Background image or canvas draw callback
   * 
   * Really Available Options:
   * connectPoints: whether to draw lines between points [boolean] 
   * pointImage: The image or function to use to draw a point [Image object or function]
   */
  initialize: function(element, options) {
    
    this.element = element;
    
    // figure out padding
    if (element.getStyle('padding-top')) {
      this.paddingTop = parseInt(element.getStyle('padding-top'));
    }
    else {
      this.paddingTop = 0;
    }
    if (element.getStyle('padding-bottom')) {
      this.paddingBottom = parseInt(element.getStyle('padding-bottom'));
    }
    else {
      this.paddingBottom = 0;
    }
    if (element.getStyle('padding-left')) {
      this.paddingLeft = parseInt(element.getStyle('padding-left'));
    }
    else {
      this.paddingLeft = 0;
    }
    if (element.getStyle('padding-right')) {
      this.paddingRight = parseInt(element.getStyle('padding-right'));
    }
    else {
      this.paddingRight = 0;
    }
    
    // figure out height and width
    this.width = parseInt(element.getWidth() - (this.paddingLeft + this.paddingRight));
    this.height = parseInt(element.getHeight() - (this.paddingTop + this.paddingBottom));
    
    this.backWidth = this.width + this.paddingLeft + this.paddingRight;
    this.backHeight = this.height + this.paddingTop + this.paddingBottom;
    
    this.redrawFrozen = false;
    
    if (options != null) {
      this.options = options; 
    }
    else {
      // default options
      this.options = new Array();
    }
  
    /* if the user gave us a min and max x, use it, otherwise, just use the 
       height and width for the parameters */
    if (!this.options.minX) {
      this.options.minX = 0;
    }
    if (!this.options.minY) {
      this.options.minY = 0;
    }
    if (!this.options.maxX) {
      this.options.maxX = this.width;
    }
    if (!this.options.maxY) {
      this.options.maxY = this.height;
    }
  
    /* set up our scales */
    this.xScale = this.width / (this.options.maxX - this.options.minX);
    this.yScale = this.height / (this.options.maxY - this.options.minY);
  
    /* if there's no pointImage set up for the options, give it the default */
    if (!this.options.pointImage) {
      this.options.pointImage = function(x, y) {
        // just draw a circle on the canvas
        this.graphContext.beginPath();
        this.graphContext.fillStyle = "#000";
        this.graphContext.arc(x, y, 2, 0, Math.PI*2, true);
        this.graphContext.fill();
      };
    }
    
    /* if there's no connectPoints callback present, give it the default */
    if (!this.options.onConnectPoints) {
      this.options.onConnectPoints = function(x1, y1, x2, y2) {
        this.graphContext.beginPath();
        this.graphContext.strokeStyle = "#000";
        this.graphContext.moveTo(x1, y1);
        this.graphContext.lineTo(x2, y2);
        this.graphContext.stroke();
      };
    }
    
    if (!this.options.afterRedraw) {
      this.options.afterRedraw = Prototype.emptyFunction;
    }
    
    this.data = new Array();
    
    // put a placeholder div in
    var placeId = element.identify() + "_placeholder";
    element.insert("<div id=\"" + placeId + 
        "\" style=\"position: relative;height: " + this.backHeight + 
        "px;width: " + this.backWidth + "px; top: " + -this.paddingTop + "px;left: " +
        -this.paddingLeft + "px;\"></div");
    this.placeHolder = $(placeId);
    
    // put the background canvas in
    var backId = element.identify() + "_background"
    this.backCanvas = this.createCanvas(backId, this.backWidth, this.backHeight, 
      0, 0);
    this.backContext = this.backCanvas.getContext('2d');
    
    // put the overlay canvas in
    var overlayId = element.identify() + "_overlay"
    this.overlayCanvas = this.createCanvas(overlayId);
    this.overlayContext = this.overlayCanvas.getContext('2d');
    
    // put the graph canvas in
    var newId = element.identify() + "_canvas";
    this.graphCanvas = this.createCanvas(newId);
    this.graphContext = this.graphCanvas.getContext('2d');
    
    /* handle drawing the background */
    if (this.options.background) {
      if (Object.isFunction(this.options.background)) {
        var handler = this.options.background.bind(this);
        handler();
      }
      else {
        this.backContext.drawImage(this.options.background, 0, 0);
      }
    }
    
    /* add a mouseover event to the canvas --
       weird thing, we have to do it to the overlay */
    if (!this.options.onMouseOver) {
      this.options.onMouseOver = Prototype.emptyFunction;
    }
    if (!this.options.onMouseOut) {
      this.options.onMouseOut = Prototype.emptyFunction;
    }
    this.hoveredItem = null;
    Event.observe(this.graphCanvas, "mousemove", this.mouseMove.bindAsEventListener(this));
    Event.observe(this.graphCanvas, "mouseout", this.mouseOut.bindAsEventListener(this));
    if (!this.options.hoverThreshold) {
      this.options.hoverThreshold = 5;
    }
    
  },
  
  /* Redraws the graph */
  redrawGraph: function() {
    this.clearPlotArea();
    this.sortData();
    
    for (var i = 0; i < this.data.length; i++) {
      x = this.data[i][0];
      y = this.data[i][1];
      
      // if there should be a line on the graph, add it
      // we want to skip the first point (it doesn't have anything to connect to)
      if (this.options.connectPoints && this.data.length > i + 1) {
        x2 = this.data[i + 1][0];
        y2 = this.data[i + 1][1];
        this.connectPoints(x, y, x2, y2);
      }
      
      // actually draw the point on the graph
      this.drawPoint(x, y);
    }
    
    // call the afterRedraw event
    var handler = this.options.afterRedraw.bind(this);
    handler();
  },
  
  addPoint: function(x, y, id) {
    // add new point to the data array
    this.data.push([x, y, id]);

    if (!this.redrawFrozen) {
      this.redrawGraph();
    }
  },
  
  /* points have to have an id to be removed */
  removePoint: function(id) {
    var match = null;
    for (var i = 0; i < this.data.length; i++) {
      if (this.data[i][2] == id) {
        match = i;
        break;
      }
    }
    
    if (match != null) {
      this.data.splice(match, 1);
    }
    
    if (!this.redrawFrozen) {
      this.redrawGraph();
    }
  },
  
  /* handles drawing a point on the canvas */
  drawPoint: function(x, y) {
    var pointImage = this.options.pointImage;
    if (Object.isFunction(pointImage)) {
      // handle custom functions
      var handler = pointImage.bind(this)
      handler(Math.round(this.scaleX(x)), Math.round(this.yToCanvas(this.scaleY(y))));
    }
    else {
      // treat it as an image
      width = pointImage.width;
      height = pointImage.height;
      x = Math.round(this.scaleX(x)) - (width / 2.0);
      y = Math.round(this.yToCanvas(this.scaleY(y))) - (height / 2.0);
      this.graphContext.drawImage(pointImage, x, y);
    }
  },
  
  /* handles connecting two points on the graph */
  connectPoints: function(x1, y1, x2, y2) {
    var handler = this.options.onConnectPoints.bind(this)
    handler(this.scaleX(x1), this.yToCanvas(this.scaleY(y1)), 
        this.scaleX(x2), this.yToCanvas(this.scaleY(y2)));
  },
  
  /* handles mouseovers */
  mouseMove: function(event) {
    // figure out where the x and y were in our canvas
    var offset = this.graphCanvas.cumulativeOffset();
    var eventX = Event.pointerX(event) - offset['left'];
    var eventY = this.yToCanvas(Event.pointerY(event) - offset['top']);
    
    // find a point that is a candidate for the hover
    var i = 0;
    var match = null;
    while (i < this.data.length) {
      point = this.data[i];
      xDiff = this.scaleX(point[0]) - eventX;
      if (xDiff <= this.options.hoverThreshold &&
          xDiff >= -this.options.hoverThreshold) {
        yDiff = this.scaleY(point[1]) - eventY;
        if (yDiff <= this.options.hoverThreshold &&
            yDiff >= -this.options.hoverThreshold) {
          match = i;
          break;
        }
      }
      i++;
    }
    
    // if we didn't get a match, do mouseOut or nothing
    if (match == null) {
      return this.unsetHovered();
    }
    
    // if we're already hovering on the item that we matched, do nothing
    if (match == this.hoveredItem) {
      return;
    }
    else {
      this.setHovered(match);
    }
  },
  
  // handles when the mouse leaves the canvas
  mouseOut: function(event) {
    this.unsetHovered();
  },
  
  // sets which item in the array is being hovered on, and calls the mouseOver
  // callback for it
  setHovered: function(id) {
    this.unsetHovered();
    
    this.hoveredItem = id;
    
    var handler = this.options.onMouseOver.bind(this);
    handler(this.data[this.hoveredItem][2], this.data[this.hoveredItem][0],
        this.data[this.hoveredItem][1], 
        Math.round(this.scaleX(this.data[this.hoveredItem][0])),
        Math.round(this.yToCanvas(this.scaleY(this.data[this.hoveredItem][1]))));
  },
  
  // unsets any previously set hovers, calling the mouseOut event if we have
  // a set hover
  unsetHovered: function() {
    if (this.hoveredItem != null) {
      var handler = this.options.onMouseOut.bind(this);
      handler(this.data[this.hoveredItem][2], this.data[this.hoveredItem][0],
          this.data[this.hoveredItem][1], this.scaleX(this.data[this.hoveredItem][0]),
          this.yToCanvas(this.scaleY(this.data[this.hoveredItem][1])));
    }
    
    this.hoveredItem = null;
  },
  
  /* sorts the array of data by the x-axis */
  sortData: function() {
    // unset the hovered item, since we go by array index right now
    this.unsetHovered();
    
    this.data.sort(function(a, b) { 
      return a[0] - b[0];
    });
  },
  
  /* converts y values to canvas coordinates */
  yToCanvas: function(y) {
    return this.height - y;
  },
  
  /* clears the graph area */
  clearPlotArea: function() {
   this.graphContext.clearRect(0, 0, this.width, this.height);
  },
  
  /* clears the overlay canvas */
  clearOverlay: function() {
    this.overlayContext.clearRect(0, 0, this.width, this.height);
  },
  
  /* freezes redrawing the graph */
  freezeRedraw: function() {
    this.redrawFrozen = true;
  },
  
  /* unfreezes redrawing
   * Optional parameter causes redraw to happen.
   */
  unfreezeRedraw: function(redrawNow) {
    
    this.redrawFrozen = false;
    
    if (redrawNow) {
      this.redrawGraph();
    }
  },
  
  /* scales an x value to the canvas */
  scaleX: function(x) {
    return (x - this.options.minX) * this.xScale;
  },
  
  /* scales a y value to the canvas */
  scaleY: function(y) {
    return (y - this.options.minY) * this.yScale;
  },
  
  /* method for creating a new canvas -- counts on excanvas for IE */
  createCanvas: function(id, width, height, left, top) {

    if (height == null) {
      height = this.height;
    }
    if (width == null) {
      width = this.width;
    }
    if (left == null) {
      left = this.paddingLeft;
    }
    if (top == null) {
      top = this.paddingTop;
    }
        
    if (typeof G_vmlCanvasManager != "undefined") {
      // if we're using excanvas
      var canvas = document.createElement('canvas');
      this.placeHolder.insert(canvas);
      canvas.style.width = width;
      canvas.style.height = height;
      canvas.style.position = "absolute";
      canvas.style.top = top;
      canvas.style.left = left;
      canvas.style.cursor = "default";
      canvas.setAttribute('id', id);
      G_vmlCanvasManager.initElement(canvas);
    }
    else {
      // other browsers
      this.placeHolder.insert("<canvas id=\"" + id + "\" width=\"" + width + "\" " +
          "height=\"" + height + "\" style=\"position: absolute; top: " + top + 
          "px; left: " + left + "px;\" />");
    }
    
    return $(id);
  }
});