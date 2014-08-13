module DetectorM {
	provides interface Detector;
	uses interface HplMsp430Interrupt as Port17int;
	uses interface HplMsp430GeneralIO as Port17;
	uses interface HplMsp430GeneralIO as Port23; 
	uses interface Timer<TMilli> as Timer1;
	uses interface LocalTime <T32khz>;
}
implementation {

	bool let_int = FALSE;
	bool single_int;
	uint32_t lastPulseTime = 0;

	async command void Detector.StartDetector(){
		call Port23.selectIOFunc();		//select IO function
		call Port23.makeOutput();		//make output
		call Port23.clr();			//turn on receiver

		ADC12CTL0 = REF2_5V + REFON; // Internal 2.5V ref on
		DAC12_1CTL = DAC12IR + DAC12AMP_5 + DAC12ENC;// Internal ref gain 1 
		DAC12_1DAT = 0x0F5C;                      // 2.4V

	}
	async command void Detector.EnableInt(bool single) {
		atomic single_int = single;

		call Port17.makeInput();				//make interrupt pin input 
		call Port17int.edge(TRUE);				//low to high transition
		
		call Port17int.clear();			//Clear interrupt flag
		call Port17int.enable();				//P1.7 interrupt enable
		
		call Timer1.startOneShot(500);
	}
	event void Timer1.fired() {
		atomic let_int = TRUE;
	}
	async command void Detector.StopDetector(){
		call Port23.set();			//turn off receiver 
		return;
	}
	async command void Detector.DisableInt(){
		call Port17int.disable();			//disable interrupt
		call Port17int.clear();			//Clear interrupt flag
		return;
	}
	async event void Port17int.fired(){
		uint32_t pulseTime;
		call Port17int.disable();			//disable interrupt

		pulseTime = call LocalTime.get();

		//if (let_int == TRUE && (pulseTime - lastPulseTime > 1300)) {		
		if (let_int == TRUE) {	
			lastPulseTime = pulseTime;
			signal Detector.PulseDetected(pulseTime);
		}
		if(single_int == TRUE) {
			call Detector.DisableInt();	
		} else {
			call Port17int.clear();				//Clear interrupt flag
			call Port17int.enable();				//P1.7 interrupt enable	
		}

		return;
	}
	default async event void Detector.PulseDetected(uint32_t firstPulseTime){
		return;
	}
}