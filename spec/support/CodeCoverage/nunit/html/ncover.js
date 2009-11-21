var hasParent = false;
var isUpdate = false;
var ncover_graph_chosen = 0; //if there is no modules then we store it here. this is for summary reports.
//This is called by the index changed.
function renderGraphUpdate() {
	var typeIndex = 0;
	switch ($('trendSelect').getValue()) {
		case 'Branch Coverage':
			$('trendTitle').update("Branch Point Coverage Trend");
			typeIndex = 1;
			break;
		case 'Method Coverage':
			$('trendTitle').update("Visited Method Percentage Trend");
			typeIndex = 2;
			break;
		case 'Cyclomatic Complexity':
		case 'Maximum Cyclomatic Complexity':
			$('trendTitle').update($('trendSelect').getValue() + " Trend");
			typeIndex = 3;
			break;
		case 'Symbol Coverage':
			$('trendTitle').update("Symbol Coverage Trend");
			typeIndex = 0;
	}

	if (hasParent) {
		parent.Modules.ncover_graph_chosen = typeIndex;
	}
	else {
		ncover_graph_chosen = typeIndex;
	}
	createCookie("ncover_graph_chosen", typeIndex, 365);

	isUpdate = true;
	renderGraph();
	isUpdate = false;
}

function renderGraph() {

	if (parent.Modules)
	{
		hasParent = true;
	}

	//this must be done first.
	
	var typeIndex = selectRememberedGraph();

	//alert(hasParent + "" + typeIndex);

	$('trendGraph').replace('<div id="trendGraph"></div>');
	var graphOptions = {
		trend: trends[typeIndex],
		connectPoints: true,
		onConnectPoints: function(x1, y1, x2, y2) {
			this.graphContext.lineWidth = 2;
			if (this.options.trend * this.options.trendModifier > 0) {
				this.graphContext.strokeStyle = "#0F0";
			}
			else if (this.options.trend * this.options.trendModifier < 0) {
				this.graphContext.strokeStyle = "#F00";
			}
			else {
				this.graphContext.strokeStyle = "#00F";
			}
			this.graphContext.moveTo(x1, y1);
			this.graphContext.lineTo(x2, y2);
			this.graphContext.stroke();
		},
		minX: 0,
		maxX: data.length + 1,
		pointImage: Prototype.emptyFunction
	};
	var ySpread = 20;
	var addPercentage = true;
	graphOptions.trendModifier = 1;
	if (typeIndex == 3) {
		/* figure out the y axis */
		var max = 1;
		data.each(function(val) {
			if (val[typeIndex] > max) {
				max = val[typeIndex];
			}
		});
		ySpread = Math.ceil(max / 5) + 1;
		addPercentage = false;
		graphOptions.trendModifier = -1;
	}

	graphOptions.maxY = ySpread * 5;
	graphOptions.background = function() {

		for (var i = 0; i <= graphOptions.maxY; i += ySpread) {
			this.backContext.beginPath();
			//top and bottom lines.
			this.backContext.strokeStyle = "#bbb";
			this.backContext.moveTo(this.paddingLeft - 0.5, this.paddingTop + this.yToCanvas(this.scaleY(i)) - 0.5);
			this.backContext.lineTo(this.paddingLeft + 4.5, this.paddingTop + this.yToCanvas(this.scaleY(i)) - 0.5);
			this.backContext.stroke();

			if (i != 0 && i < graphOptions.maxY) {
				this.backContext.beginPath();
				//middle lines not at 0 and 100
				this.backContext.strokeStyle = "#bbb";
				this.backContext.moveTo(this.paddingLeft + 4.5, this.paddingTop + this.yToCanvas(this.scaleY(i)) - 0.5);
				this.backContext.lineTo(this.backWidth - this.paddingRight - 0.5, this.paddingTop + this.yToCanvas(this.scaleY(i)) - 0.5);
				this.backContext.stroke();
			}

			this.backContext.beginPath();
			this.backContext.moveTo(this.paddingLeft - 0.5, 0 + this.paddingTop);
			this.backContext.lineTo(this.paddingLeft - 0.5, this.backHeight - this.paddingBottom - 0.5);
			this.backContext.lineTo(this.backWidth - this.paddingRight - 0.5, this.backHeight - this.paddingBottom - 0.5);
			this.backContext.lineTo(this.backWidth - this.paddingRight - 0.5, this.paddingTop - 0.5);
			this.backContext.lineTo(this.paddingLeft - 0.5, this.paddingTop - 0.5);
			this.backContext.stroke();

			var element = new Element("div");
			element.addClassName("y-axis");
			element.insert(i + (addPercentage ? "%" : ""));
			element.setStyle({ top: this.paddingTop + this.yToCanvas(this.scaleY(i)) + 0.5 + "px" });
			this.placeHolder.insert(element);
		}
	};

	var trendGraph = new GraphBase($('trendGraph'), graphOptions);

	var x = 1;
	trendGraph.freezeRedraw();
	data.each(function(val) {
		trendGraph.addPoint(x, val[typeIndex]);
		x += 1;
	});
	trendGraph.unfreezeRedraw(true);
}

function selectRememberedGraph() {
	var chosen = 0;
	if (hasParent) {
		if (parent.Modules.ncover_graph_chosen) {
			chosen = parent.Modules.ncover_graph_chosen;
		}
	}
	else if (ncover_graph_chosen) {
		chosen = ncover_graph_chosen;
	}
	else if (readCookie("ncover_graph_chosen")) {
		var cookieVal = readCookie("ncover_graph_chosen");
		chosen = cookieVal;
	}
	
	if (!isUpdate) {
		$('trendSelect')[chosen].selected = "1";
	}
	return chosen;
}

// cookie handling functions
function createCookie(name, value, days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	}
	else var expires = "";
	document.cookie = name + "=" + value + expires + "; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name, "", -1);
}