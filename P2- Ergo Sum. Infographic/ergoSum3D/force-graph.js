const CAMERA_DISTANCE2NODES_FACTOR = 150;

const ForceGraph = Kapsule({

	props: {
		width: { default: window.innerWidth },
		height: { default: window.innerHeight },
		graphData: { default: {
			nodes: {},
			links: [] // [from, to]
		}},
		numDimensions: { default: 3 },
		nodeRelSize: { default: 4 }, // volume per val unit
		lineOpacity: { default: 0.2 },
		valAccessor: { default: node => node.val },
		nameAccessor: { default: node => node.name },
		colorAccessor: { default: node => node.color },
		warmUpTicks: { default: 0 }, // how many times to tick the force engine at init before starting to render
		coolDownTicks: { default: Infinity },
		coolDownTime: { default: 60000 } // ms
	},
	// ........................................................................................................................................

	init: (domNode, state) => {
		// Wipe DOM
		domNode.innerHTML = '';

		// Add nav info section
		const navInfo = document.createElement('div');
		navInfo.classList.add('graph-nav-info');
		navInfo.innerHTML = "MOVE mouse &amp; press LEFT/A: rotate, MIDDLE/S: zoom, RIGHT/D: pan";
		domNode.appendChild(navInfo);

		// Setup tooltip with Text
		const toolTipElem = document.createElement('div');
		toolTipElem.classList.add('graph-tooltip');
		domNode.appendChild(toolTipElem);

		// ........................................................................................................................................

		// Capture mouse coords on move
		const raycaster = new THREE.Raycaster();
		const mousePos = new THREE.Vector2();
		mousePos.x = -2; // Initialize off canvas
		mousePos.y = -2;
		domNode.addEventListener("mousemove", ev => {
			// update the mouse pos
			const offset = getOffset(domNode),
			relPos = {
				x: ev.pageX - offset.left,
				y: ev.pageY - offset.top
			};
			mousePos.x = (relPos.x / state.width) * 2 - 1;
			mousePos.y = -(relPos.y / state.height) * 2 + 1;

			// Move tooltip
			toolTipElem.style.top = (relPos.y - 40) + 'px';
			toolTipElem.style.left = (relPos.x - 20) + 'px';

			// ........................................................................................................................................
			function getOffset(el) {
				const rect = el.getBoundingClientRect(),
				scrollLeft = window.pageXOffset || document.documentElement.scrollLeft,
				scrollTop = window.pageYOffset || document.documentElement.scrollTop;
				return { top: rect.top + scrollTop, left: rect.left + scrollLeft };
			}
		}, false);

		// ........................................................................................................................................

		// Setup camera
		state.camera = new THREE.PerspectiveCamera();
		state.camera.far = 20000;
		state.camera.position.z = 1000;

		// Setup scene
		const scene = new THREE.Scene();
		//scene.background = new THREE.Color();
		scene.add(state.graphScene = new THREE.Group());

		// ........................................................................................................................................

		// Add lights
		scene.add(new THREE.AmbientLight(0xbbbbbb));
		scene.add(new THREE.DirectionalLight(0xffffff, 0.6));

		// Setup renderer
		// https://stackoverflow.com/questions/16177056/changing-three-js-background-to-transparent-or-other-color
		state.renderer = new THREE.WebGLRenderer( { alpha: true } ); // init like this
		state.renderer.setClearColor( 0xffffff, 0 ); // second param is opacity, 0 => transparent
		domNode.appendChild(state.renderer.domElement);

		// Add camera interaction
		const tbControls = new TrackballControls(state.camera, state.renderer.domElement);

		// ........................................................................................................................................

		// Kick-off renderer
		(function animate() { // IIFE
			// Update tooltip
			raycaster.setFromCamera(mousePos, state.camera);
			const intersects = raycaster.intersectObjects(state.graphScene.children);
			// console.log(intersects);
			toolTipElem.innerHTML = intersects.length ? intersects[0].object.name || '' : '';

			// Frame cycle
			tbControls.update();
			state.renderer.render(scene, state.camera);
			requestAnimationFrame(animate);
		})();
	},

	update: state => {
		resizeCanvas();

		while (state.graphScene.children.length) { state.graphScene.remove(state.graphScene.children[0]) } // Clear the place

		// Build graph with data
		const d3Nodes = [];
		for (let nodeId in state.graphData.nodes) { // Turn nodes into array
			const node = state.graphData.nodes[nodeId];
			node._id = nodeId;
			d3Nodes.push(node);
		}
		const d3Links = state.graphData.links.map(link => {
			// console.log(link);
			// return { source: link[0], target: link[1] };
			return { source: link.source, target: link.target	 };
		});

		// ........................................................................................................................................
		// console.log(d3Nodes);

		// Add WebGL objects
		d3Nodes.forEach(node => {

			// MATERIAL SAMPLES .......................................................................................................................
			// https://github.com/mrdoob/three.js/blob/master/examples/webgl_materials.html


			//  materials.push( new THREE.MeshLambertMaterial( { map: texture, transparent: true } ) );
			// 	materials.push( new THREE.MeshLambertMaterial( { color: 0xdddddd } ) );
			// 	materials.push( new THREE.MeshPhongMaterial( { color: 0xdddddd, specular: 0x009900, shininess: 30, flatShading: true } ) );
			// 	materials.push( new THREE.MeshNormalMaterial() );
			// 	materials.push( new THREE.MeshBasicMaterial( { color: 0xffaa00, transparent: true, blending: THREE.AdditiveBlending } ) );
			// 	materials.push( new THREE.MeshBasicMaterial( { color: 0xff0000, blending: THREE.SubtractiveBlending } ) );
			// 	materials.push( new THREE.MeshLambertMaterial( { color: 0xdddddd } ) );
			// 	materials.push( new THREE.MeshPhongMaterial( { color: 0xdddddd, specular: 0x009900, shininess: 30, map: texture, transparent: true } ) );
			// 	materials.push( new THREE.MeshNormalMaterial( { flatShading: true } ) );
			// 	materials.push( new THREE.MeshBasicMaterial( { color: 0xffaa00, wireframe: true } ) );
			// 	materials.push( new THREE.MeshDepthMaterial() );
			// 	materials.push( new THREE.MeshLambertMaterial( { color: 0x666666, emissive: 0xff0000 } ) );
			// 	materials.push( new THREE.MeshPhongMaterial( { color: 0x000000, specular: 0x666666, emissive: 0xff0000, shininess: 10, opacity: 0.9, transparent: true } ) );
			// 	materials.push( new THREE.MeshBasicMaterial( { map: texture, transparent: true } ) );

			var texture = new THREE.Texture( generateTexture() );
			texture.needsUpdate = true;

			// Spheres geometry

			const nodeMaterial = new THREE.MeshLambertMaterial( { color: 0x00BABA, transparent: true, wireframe: true  } );
			nodeMaterial.opacity = 0.3; // original 0.75
			const nodeInsideMaterial = new THREE.MeshPhongMaterial( { color: 0x047580, shininess: 30, flatShading: true } );

			// const nodeInsideMaterial = new THREE.MeshLambertMaterial( { color: 0x047580,shininess: 30, flatShading: true } );
			nodeInsideMaterial.opacity = 0.9; // original 0.75

			const sphere = new THREE.Mesh(
				// new THREE.SphereGeometry(Math.cbrt(state.valAccessor(node) || 1) * state.nodeRelSize, 8, 8),
				new THREE.SphereGeometry(10, 16, 16),
				nodeMaterial
			);

			const sphereInside = new THREE.Mesh(
				new THREE.SphereGeometry(4, 16, 16),
				nodeInsideMaterial
			);

			//console.log(node);
			sphere.name = node.name || '';
			//console.log(sphere);

			state.graphScene.add(node._sphere = sphere);
			state.graphScene.add(node._sphereInside = sphereInside);

			// https://gist.github.com/leefsmp/38926bf2c379f604f9b5
			// var div = document.createElement('div');


			// http://www.billdwhite.com/wordpress/2015/01/12/d3-in-3d-combining-d3-js-and-three-js/
			// create a div with each node to include the names
			// d3.select("#3d-graph").append("div") //# div with id
      //           .style("font-size", "10px")
      //           .text(function(d) {
      //               return node.name; // take name
      //           });
            // var object = new THREE.CSS3DObject();
            // state.graphScene.add(node._textNames = object);
		});




		// LINES ................................................................................................................................

		// console.log(d3Links);
		const lineMaterial = new THREE.LineBasicMaterial({ color: 0xf0f0f0, linewidth: 10, transparent: false });
		lineMaterial.opacity = state.lineOpacity;
		d3Links.forEach(link => {
			// console.log(link);
			const line = new THREE.Line(new THREE.Geometry(), lineMaterial);
			line.geometry.vertices=[new THREE.Vector3(0,0,0), new THREE.Vector3(0,0,0)];
			line.renderOrder = 10; // Prevent visual glitches of dark lines on top of spheres by rendering them last

			const fromName = getNodeName(link.source.name),
			toName = getNodeName(link.target.name);
			if (fromName && toName) { line.name = `${fromName} > ${toName}`; }

			state.graphScene.add(link._line = line);
			//console.log(fromName);
			function getNodeName(nodeId) {
				return state.nameAccessor(state.graphData.nodes[nodeId]);
			}
		});

		state.camera.lookAt(state.graphScene.position);
		state.camera.position.z = Math.cbrt(d3Nodes.length) * CAMERA_DISTANCE2NODES_FACTOR;

		// console.log(d3Links);
		// Add force-directed layout
		const layout = d3_force.forceSimulation()
		.numDimensions(state.numDimensions)
		.nodes(d3Nodes)
		.force('link', d3_force.forceLink().id(d => d._id).links(d3Links))
		.force('charge', d3_force.forceManyBody())
		.force('center', d3_force.forceCenter())
		.stop();

		for (let i=0; i<state.warmUpTicks; i++) { layout.tick(); } // Initial ticks before starting to render

		let cntTicks = 0;
		const startTickTime = new Date();
		layout.on("tick", layoutTick).restart();


		// TEXTURE ................................................................................................................................

		function generateTexture() {
			var canvas = document.createElement( 'canvas' );
			canvas.width = 256;
			canvas.height = 256;
			var context = canvas.getContext( '2d' );
			var image = context.getImageData( 0, 0, 256, 256 );
			var x = 0, y = 0;
			for ( var i = 0, j = 0, l = image.data.length; i < l; i += 4, j ++ ) {
				x = j % 256;
				y = x == 0 ? y + 1 : y;
				image.data[ i ] = 255;
				image.data[ i + 1 ] = 255;
				image.data[ i + 2 ] = 255;
				image.data[ i + 3 ] = Math.floor( x ^ y );
			}
			context.putImageData( image, 0, 0 );
			return canvas;
		}
		// CANVAS ................................................................................................................................

		function resizeCanvas() {
			if (state.width && state.height) {
				state.renderer.setSize(state.width, state.height);
				state.camera.aspect = state.width/state.height;
				state.camera.updateProjectionMatrix();
			}
		}

		// layoutTick ................................................................................................................................

		function layoutTick() {
			if (cntTicks++ > state.coolDownTicks || (new Date()) - startTickTime > state.coolDownTime) {
				layout.stop(); // Stop ticking graph
			}

			// Update nodes position
			d3Nodes.forEach(node => {

				const sphere = node._sphere;
				sphere.position.x = node.x;
				sphere.position.y = node.y || 0;
				sphere.position.z = node.z || 0;

				const sphereInside = node._sphereInside;
				sphereInside.position.x = node.x;
				sphereInside.position.y = node.y || 0;
				sphereInside.position.z = node.z || 0;

				// const textNames = node._textNames;
				// textNames.position.x = node.x;
				// textNames.position.y = node.y || 0;
				// textNames.position.z = node.z || 0;
			});

			// Update links position
			d3Links.forEach(link => {
				const line = link._line;

				line.geometry.vertices = [
					new THREE.Vector3(link.source.x, link.source.y || 0, link.source.z || 0),
					new THREE.Vector3(link.target.x, link.target.y || 0, link.target.z || 0)
				];

				line.geometry.verticesNeedUpdate = true;
				line.geometry.computeBoundingSphere();
			});
		}
	}
});
