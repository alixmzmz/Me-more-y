function getGraphDataSets() {

  // Color brewer paired set
  const colors = ['#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928'];

  // ........................................................................................................................................

  const loadMiserables = function(Graph) {
    qwest.get('miserables.json').then((_, data) => {
      const nodes = {};
      data.nodes.forEach(node => { nodes[node.id] = node }); // Index by ID

      Graph
      .nameAccessor(node => node.id)
      .colorAccessor(node => parseInt(colors[node.group%colors.length].slice(1),16))
      .graphData({
        nodes: nodes,
        links: data.links.map(link => [link.source, link.target])
      });
    });
  };
  loadMiserables.description = "<em>Les Miserables</em> data (<a href='https://bl.ocks.org/mbostock/4062045'>4062045</a>)";

  // ........................................................................................................................................

  // LOAD REMOTE GOOGLE SPREADSHEET json
  // http://pipetree.com/qmacro/blog/2013/10/04/sheetasjson-google-spreadsheet-data-as-json/
  // d3.json("https://script.googleusercontent.com/macros/echo?user_content_key=VmkkBkrI7dRh1pmJOVt_qmTM7f2b6U8IPDMhIyl6qDCu7dFy-Qski92olBMgN8AVKmXBSuEe8yS_X5P4oQXrGTtFOXrBNDICOJmA1Yb3SEsKFZqtv3DaNYcMrmhZHmUMWojr9NvTBuBLhyHCd5hHa0fnhNOx0Ow92_YI4rPqcBlNhhLv7hexLy59DC9dflQLqZV46-Z6SFW9lmyXvj_BD2LvF45J6BTkLnivYWCPhxhJua7SC-3WMGx6_Ffe3Un31cw7r8lXlVO37IwazBz5xzbBQR0mtaOM&lib=M2pvbKG4PsZSw6uJJg5VSoH79Txk7FZAn", function (json) {

  const loadErgoSum = function(Graph) {
    //qwest.get('https://script.googleusercontent.com/macros/echo?user_content_key=VmkkBkrI7dRh1pmJOVt_qmTM7f2b6U8IPDMhIyl6qDCu7dFy-Qski92olBMgN8AVKmXBSuEe8yS_X5P4oQXrGTtFOXrBNDICOJmA1Yb3SEsKFZqtv3DaNYcMrmhZHmUMWojr9NvTBuBLhyHCd5hHa0fnhNOx0Ow92_YI4rPqcBlNhhLv7hexLy59DC9dflQLqZV46-Z6SFW9lmyXvj_BD2LvF45J6BTkLnivYWCPhxhJua7SC-3WMGx6_Ffe3Un31cw7r8lXlVO37IwazBz5xzbBQR0mtaOM&lib=M2pvbKG4PsZSw6uJJg5VSoH79Txk7FZAn').then((_, data) => {
    qwest.get('ergosum.json').then((_, data) => {
      const nodes = {}; // empty array of nodes

      // console.log(json); -- read on the console the json content
      var links = data.links; // assign json to the variable links

      /* ............... LINKS ..............................................................................................................................*/

      // goes through each link in links to extract all nodes
      // parse links to nodes
      links.forEach(function(link){  // fill the array with links content (source and target nodes from links)
        // link composed of source + target
        // console.log(link.target);

        link.source = nodes[link.source] ||
        (nodes[link.source] = { group: link.group,
          location: link.location,
          weight:  link.weight,
          name: link.source,
          facebook: link.facebook,
          linkedin: link.linkedin,
          instagram: link.instagram,
          alive: link.alive,
          text: link.text
        });
        link.target = nodes[link.target] ||
        (nodes[link.target] = {
          group: link.group,
          location: link.location,
          weight:  link.weight,
          name: link.target,
          facebook: link.facebook,
          linkedin: link.linkedin,
          instagram: link.instagram,
          alive: link.alive,
          text: link.text
        });
      });

      // console.log(nodes);
      // console.log(links);

      Graph
      .nameAccessor(node => node.name)
      .colorAccessor(node => parseInt(colors[node.group%colors.length].slice(1),16))
      .graphData({
        nodes: nodes,
        links: links
      });
    });
  };
  loadErgoSum.description = "<em>Ergo Sum</em>";

  // ........................................................................................................................................
  return [loadErgoSum];
}
