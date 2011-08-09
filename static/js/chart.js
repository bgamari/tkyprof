var w = 600,
    h = 600,
    r = Math.min(w, h) / 2,
    x = d3.scale.linear().range([0, 2*Math.PI]),
    y = d3.scale.sqrt().range([0, r]),
    color = d3.scale.category20c();

var vis = d3.select("#chart").append("svg:svg")
  .attr("width", w)
  .attr("height", h)
  .append("svg:g")
  .attr("transform", "translate(" + w/2 + "," + h/2 + ")");

var partition = d3.layout.partition()
  .value(function(d) { return d.individualTime; })
  .children(function(d) { return d.subForest; });

var arc = d3.svg.arc()
  .startAngle(function(d) { return Math.max(0, Math.min(2*Math.PI, x(d.x))); })
  .endAngle(function(d) { return Math.max(0, Math.min(2*Math.PI, x(d.x + d.dx))); })
  .innerRadius(function(d) { return Math.max(0, y(d.y)); })
  .outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });

// d3.json("http://localhost:3000/reports", function(json) {
//   var path = vis.data([json]).selectAll("path")
//     .data(partition.nodes)
//     .enter().append("svg:path")
//     .attr("class", function(d) { return "cost-centre-" + d.no; })
//     .attr("d", arc)
//     .style("fill", function(d) { return color((d.children ? d : d.parent).name); })
//     .on("click", click)
//     .each(stash);

//   d3.select("#time").on("click", function() {
//     path
//       .data(partition.value(function(d) { return d.individualTime; }))
//       .transition()
//       .duration(500)
//       .attrTween("d", arcTween);

//     d3.select("#time").classed("active", true);
//     d3.select("#alloc").classed("active", false);
//   });

//   d3.select("#alloc").on("click", function() {
//     path
//       .data(partition.value(function(d) { return d.individualAlloc; }))
//       .transition()
//       .duration(500)
//       .attrTween("d", arcTween);

//     d3.select("#time").classed("active", false);
//     d3.select("#alloc").classed("active", true);
//   });

//   function click(d) {
//     path.transition()
//       .duration(500)
//       .attrTween("d", arcTweenZoom(d));
//   }
// });

// // Stash the old values for transition.
// function stash(d) {
//   d.x0 = d.x;
//   d.dx0 = d.dx;
// }

// // Interpolate the arcs in data space.
// function arcTween(a) {
//   var i = d3.interpolate({x: a.x0, dx: a.dx0}, a);
//   return function(t) {
//     var b = i(t);
//     a.x0 = b.x;
//     a.dx0 = b.dx;
//     return arc(b);
//   };
// }

// function arcTweenZoom(d) {
//   var xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
//       yd = d3.interpolate(y.domain(), [d.y, 1]),
//       yr = d3.interpolate(y.range(), [d.y ? 20 : 0, r]);
//   return function(d, i) {
//     return i
//       ? function(t) { return arc(d); }
//     : function(t) { x.domain(xd(t)); y.domain(yd(t)).range(yr(t)); return arc(d); };
//   };
// }
