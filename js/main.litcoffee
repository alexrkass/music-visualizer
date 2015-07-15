
See [this blog](http://srchea.com/experimenting-with-web-audio-api-three-js-webgl) for a very helpful tutorial.


First set up a context upon which all the functions
used to parse the audio will be called:

	window.perlin = new ImprovedNoise();
	noisePos = Math.random()*100;

	try audio = new AudioContext()

Then open an HTTP request to asynchronously get your audio file:

	url = 'data/11 Where I\'m Trying To Go (Marvel Years Remix).mp3';
	request = new XMLHttpRequest();
	request.open('GET', url, true);
	request.responseType = "arraybuffer";

The AnalyserNode takes the current frequency data from the AudioBufferSourceNode, smoothes it, and outputs to the ScriptProcessorNode. We define it here so that

	window.analyser = audio.createAnalyser();
	analyser.smoothingTimeConstant = 1;
	analyser.fftSize = 512;

When the request returns, onload sets up the scene and finishes by playing the source and starting the

	request.onload = ()->
		audio.decodeAudioData(
			request.response,
			(buffer) ->

The AudioBufferSourceNode contains the input audio data and outputs to the analyser and output.

				source = audio.createBufferSource();
				source.buffer = buffer;
				source.connect(audio.destination);

The ScriptProcessorNode takes data from the analyser as its input and outputs to the destination node which plays the sound.

				sourceJs = audio.createScriptProcessor(2048,1,1)
				sourceJs.buffer = buffer
				source.connect(analyser);
				analyser.connect(sourceJs);

Create the oscilloscope and connect the AudioBufferSourceNode to it.
.onaudioprocess is the event handler that runs when the ScriptProcessorNode takes in a byte of audio data.

				sourceJs.onaudioprocess = (e) ->
					array = new Uint8Array(analyser.frequencyBinCount);
					analyser.getByteFrequencyData(array);
				source.loop = true
				startViz(source);
				return
			);
		return

	startViz = (source)->
		source.start(0);
		animate();

	animate = ()->
		requestAnimationFrame(animate);
		LoopVisualizer.update(noisePos);
		noisePos += 0.005;
		renderer.render(scene, camera);
		return

Finally, send the request which begins the flow that ends with the source.start function being called.


	request.send()
