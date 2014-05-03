interface Detector {
	async command void StartDetector();
	async command void StopDetector();
	async event void PulseDetected(uint32_t *firstPulseTime);
}