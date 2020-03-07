NetAddr.localAddr
o = Server.local.options;
o.device = "Duet USB";
(
SynthDef('storySynth', {
	arg pitch = 200, pan = 0.0, amp = 0.05;
	var sound = SinOsc.ar(pitch, mul:amp);
	var linen = Env.linen(0.01, sustainTime:5, releaseTime:1);
	var env = EnvGen.kr(linen, doneAction:2);
	Out.ar(0, Pan2.ar(sound * env, pan));
}).add;
)

(
OSCdef('storyListen', {
	arg msg;
	Synth('storySynth', [pitch:msg[1], pan:msg[2], amp:msg[3]]);
	msg[3].postln;
},"\story");
)
