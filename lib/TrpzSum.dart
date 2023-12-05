class TrpzSum{
  double _sum = 0.0;
  double _lastSample = 0.0;
  final double _sampleRateInSeconds;


  TrpzSum(this._sampleRateInSeconds);

  void addSample(double sample){
    _sum +=  (_lastSample + sample) / 2.0 * _sampleRateInSeconds ;
    _lastSample = sample;
  }


  double getSumValue() => _sum;
}