configuration PulserC {
	provides interface Pulser;
}

implementation {
	components PulserM, HplMsp430GeneralIOC;

	Pulser = PulserM;
	PulserM.Port24 -> HplMsp430GeneralIOC.Port24;
	PulserM.Port25 -> HplMsp430GeneralIOC.Port25;

	components new TimerMilliC() as Timer0;
	//components new Msp430Timer32khzC() as Timer0;
	PulserM.Timer0 -> Timer0;

	//components Alarm32khzC;
	//Pulser.Alarm -> Alarm32khzC;

	components LocalTime32khzC;
	PulserM.LocalTime -> LocalTime32khzC; 

}