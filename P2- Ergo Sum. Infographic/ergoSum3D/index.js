const Graph = ForceGraph()
	(document.getElementById("3d-graph"));

let curDataSetIdx,
	numDim = 3; // 3D

const dataSets = getGraphDataSets();

let toggleData;
(toggleData = function() {
	curDataSetIdx = curDataSetIdx === undefined ? 0 : (curDataSetIdx+1)%dataSets.length;

	const dataSet = dataSets[curDataSetIdx];

	reloadGraph();
})(); // IIFE init

let toggleDimensions = function(numDimensions) {
	numDim = numDimensions;
	reloadGraph();
};

function reloadGraph() {
	dataSets[curDataSetIdx](Graph
		.resetProps()
		.numDimensions(numDim)
	);
}
