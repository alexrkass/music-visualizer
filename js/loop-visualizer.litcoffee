	window.LoopVisualizer = (()->
		console.log("Visualizer being defined");
		levels = []
		colors = []
		rings = []
		INIT_RADIUS = 50;
		SEGMENTS = 512;
		loopShape = new THREE.Shape();
		loopShape.absarc( 0, 0, INIT_RADIUS, 0, Math.PI*2, false );
		loopGeom = loopShape.createPointsGeometry(SEGMENTS/2);
		loopGeom.dynamic = true;
		RINGCOUNT = 160;
		init = () ->
			console.log("Visualizer initialize started")
			container = document.createElement('div');
			document.body.appendChild(container);
			window.camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1, 1000000);
			camera.position.z = 2000;
			window.scene = new THREE.Scene();
			scene.add(camera);
			window.renderer = new THREE.WebGLRenderer({
				antialias : false,
				sortObjects : false
			});
			renderer.setSize(window.innerWidth, window.innerHeight);
			container.appendChild(renderer.domElement);
			freqByteData = new Uint8Array(analyser.frequencyBinCount);
			timeByteData = new Uint8Array(analyser.frequencyBinCount);

			loopHolder = new THREE.Object3D();
			scene.add(loopHolder);
			scale = 1;
			for ring in [1,RINGCOUNT]
				m = new THREE.LineBasicMaterial(
					color: 0xffffff,
					linewidth: 1 ,
					opacity : 0.7,
					blending : THREE.AdditiveBlending,
					depthTest : false,
					transparent : true
				)
				line = new THREE.Line(loopGeom, m);
				rings.push(line);
				scale *= 1.05;
				line.scale.x = scale;
				line.scale.y = scale;
				loopHolder.add(line);
				levels.push(0);
				colors.push(0);
				return

		console.log("here");
		update = (noisePos)->
			freqByteData = new Uint8Array(analyser.frequencyBinCount);
			timeByteData = new Uint8Array(analyser.frequencyBinCount);
			analyser.getByteFrequencyData(freqByteData);
			analyser.getByteTimeDomainData(timeByteData);
			sum = 0;
			BIN_COUNT = 512;
			for i in [1,BIN_COUNT]
				sum += freqByteData[i];
			aveLevel = sum / BIN_COUNT;
			scaled_average = (aveLevel / 256);
			levels.push(scaled_average);
			levels.shift(1);
			n = Math.abs(perlin.noise(noisePos, 0, 0));
			colors.push(n);
			colors.shift(1);
			for j in [1,SEGMENTS]
				loopGeom.vertices[j].z = timeByteData[j]*2;
				loopGeom.vertices[SEGMENTS].z = loopGeom.vertices[0].z;
			loopGeom.verticesNeedUpdate = true;
			for i in [1,RINGCOUNT]
				ringId = RINGCOUNT - i - 1;
				normLevel = levels[ringId] + 0.01;
				hue = colors[i];
				rings[i].material.color.setHSL(hue, 1, normLevel*.8);
				rings[i].material.linewidth = normLevel*3;
				rings[i].material.opacity = normLevel;
				return
		init:init,
		update:update,
		);
	LoopVisualizer.init();
