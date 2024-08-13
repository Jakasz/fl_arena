enum BossInfo {
  angolt('Spider', 12600000, 10800000),
  kiaron('Kiaron', 16200000, 10800000),
  grish('Grish', 19800000, 10800000),
  inferno('Inferno', 23400000, 10800000);

  const BossInfo(this.name, this.respawn, this.delay);

  final String name;
  final int respawn, delay;
}
