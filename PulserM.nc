module PulserM {
	provides interface Pulser;
	uses interface HplMsp430GeneralIO as Port24;
	uses interface HplMsp430GeneralIO as Port25;
	uses interface Timer<TMilli> as Timer0;	
	uses interface LocalTime <T32khz>;

	uses interface Alarm<T32khz, uint32_t> as Alarm;
}
implementation {
	command void Pulser.Init() {
		// Port 2.5==LOW -> US TS enabled
		call Port25.makeOutput();	//Port 2.5 set as output
		call Port25.clr(); 		//enable Ultrasonic Transmitter

		call Port24.selectModuleFunc();
		call Port24.makeOutput();
	}
	command void Pulser.SendPulse(uint32_t *startTime) {
		TA0CCR0 = 12; // Produce 40KHz with 50% duty cycle
		TA0CCR2 = 6;

		TA0CCTL2 = OUTMOD_3; // OUT=1 when counting to TACCR1 value. OUT=0 when counting TACCR0 value.

		TA0CTL = TASSEL_2 + ID_1 + MC_1;

		
		*startTime = call LocalTime.get();

		//call Timer0.startOneShot(40);
		call Alarm.start(40);

		return;
	}
	event void Timer0.fired(){}
	async event void Alarm.fired()	
	{
		TACCR0 = 0;
		//call Port24.makeInput();	//Port 2.4 input (no output)
		
	}
	command void Pulser.Stop() {
		call Port25.set(); 	//disable Ultrasonic Transmitter
	}
}