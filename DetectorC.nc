configuration DetectorC {
	provides interface Detector;
}

implementation {
	components DetectorM, HplMsp430InterruptC, HplMsp430GeneralIOC;


	Detector = DetectorM;
	DetectorM.Port17int -> HplMsp430InterruptC.Port17;	
	DetectorM.Port17 -> HplMsp430GeneralIOC.Port17;
	DetectorM.Port23 -> HplMsp430GeneralIOC.Port23;  

	components new TimerMilliC();
	DetectorM.Timer1 -> TimerMilliC;

	components LocalTime32khzC;
	DetectorM.LocalTime -> LocalTime32khzC; 
}