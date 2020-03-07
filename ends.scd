NetAddr.langPort;
Speech.init(3); //number of simultaneous voices
o = Server.local.options;
o.device = "Fireface UFX (23209141)";

(
f = {
	arg phrase = "default", channel = 0;
	Speech.setSpeechVolume(channel,0.05);
	Speech.setSpeechRate(channel, 250);
	Speech.channels[channel].speak(phrase);
};
)

(
SynthDef('storySynth', {
	arg pitch = 200, pan = 0.0, amp = 0.05, sus = 1, rel =2;
	var sound = SinOsc.ar(pitch, mul:amp);
	var linen = Env.linen(0.01, sustainTime:sus, releaseTime:rel);
	var env = EnvGen.kr(linen, doneAction:2);
	Out.ar(0, Pan2.ar(sound * env, pan));
}).add;
)


(
OSCdef('phraseListen', {
	arg msg;
	f.(format("%",msg[1]),msg[2]).value;
},"\phrase");
)


(
OSCdef('storyListen', {
	arg msg;
	Synth('storySynth', [pitch:msg[1], pan:msg[2], sus: rand(1.0), rel: rand(2.0)]);
	msg[2].postln;
},"\story");
)