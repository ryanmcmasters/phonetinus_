/*
phonetinus.
for any number of cellphones in a wide open space.

R.McMASTERS

p_0000



made with the generous support of the Pittsburgh Parks Conservancy
& University of Pittsburgh Humanities Center.
*/

(
s.boot;
s.waitForBoot{

	//the synths.
	//the fireflies.
	SynthDef(\lightsound, {
		arg freq = 512, dur = 1.0, amp = 0.5;
		var sin, env;
		env = XLine.kr(amp,0.0001,dur,doneAction:2);
		sin = SinOsc.ar([freq], mul:env);
		Out.ar([0,1], sin);
	}).load(s);

	//the background noise.
	~crackle=SynthDef(\crackle,{
		arg dense = 2, q = 0.01, amp = 0.2;
		var dust;
		dust = RHPF.ar(Dust2.ar(dense, amp),[2000],q);
		Out.ar([0,1], dust);
	}).load(s);


	//the window.
	~w1 = Window.new("phonetinus p_0000", Rect(0, 0, Window.availableBounds.width, Window.availableBounds.height))
	.background_(Color.black)
	.front
	.alwaysOnTop_(true);

	//the window reset. [as needed]
	~w1.background_(Color.black);


	//some variables.
	~t = 15; //the length of the piece [minutes].
	~mod = (4/3); // the blink constant.
	~i = ~t*~mod; // an iterative modulation factor.
	~l = 6; //duration of synth loop [seconds].
	~x = (60/~l); //humber of times golden repeat.


	//the piece.

	//crackle sequence.
	AppClock.sched(0,
		Routine({
			~crackle=Synth(\crackle);
			(~i*3).wait;
			27.do{
				arg count;
				~crackle.set(\dense, (2+((count.postln+1)/2)), \q,(1/(20*(count+2))),\amp,(0.2+((count)*0.01)));
				(~i).wait};
			(~i*2).wait;
			12.do{
				arg count;
				count.postln;
				~crackle.set(\dense,(13/(count+1)),\amp,(0.47-(count*0.005)));
				(~i).wait};
			(~i*2).wait;
			~crackle.free;
			"the end".postln;
	}));

	//the firefly sequence.
	AppClock.sched((~t*0),
		Routine({[2,3,4,6,4,3,5,4,6,10,6,~x,10,4,2].do{
			arg counter;
			counter.do{
				counter.postln;
				t = ((~t*4/counter)-~l).rand.postln;
				t.wait;
				3.do{
					arg counter;
					~a=Synth(\lightsound,[\dur,6,\freq,1000]);
					~w1.background_(Color.new255(0,255,255,((counter+1)*85)));
					1.wait;
					~w1.background_(Color.black);
					1.wait};
				((~t*4/counter)-(t+~l)).postln.wait}}};
	));
}
)