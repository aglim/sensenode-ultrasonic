interface Pulser {
	command void Init();
	command void SendPulse(uint32_t *startTime);
	command void Stop();
}