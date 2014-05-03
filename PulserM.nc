module PulserM {
	provides interface Pulser;
	uses interface HplMsp430GeneralIO as Port24;
	uses interface HplMsp430GeneralIO as Port25;
	uses interface Timer<TMilli> as Timer0;
	//uses interface Alarm<T32khz, uint16_t> as Alarm;
	uses interface LocalTime <T32khz>;
}
implementation {
	command void Pulser.SendPulse(uint32_t *startTime) {
				// Port 2.5==LOW -> US TS enabled
		call Port25.makeOutput();	//Port 2.5 set as output
		call Port25.clr(); 		//enable Ultrasonic Transmitter

		TA0CCR0 = 12; // Produce 40KHz with 50% duty cycle
		TA0CCR2 = 6;

		TA0CCTL2 = OUTMOD_3; // OUT=1 when counting to TACCR1 value. OUT=0 when counting TACCR0 value.

		TA0CTL = TASSEL_2 + ID_1 + MC_1;

		call Port24.selectModuleFunc();
		call Port24.makeOutput();

		*startTime = call LocalTime.get();

		call Timer0.startOneShot(10);
		//call Alarm.start(10);

		return;
	}
	event void Timer0.fired()
	//event void Alarm.fired()
	{
		call Port24.makeInput();	//Port 2.4 input (no output)
		call Port25.set(); 	//disable Ultrasonic Transmitter
	}
}