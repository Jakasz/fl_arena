class FirebaseData {
  FirebaseData(
      {required this.pointName,
      required this.pointId,
      required this.eliteName,
      required this.rewpawnTime,
      required this.pointIndex});
  final String pointName, eliteName, pointId;
  final int pointIndex;
  double rewpawnTime;

  factory FirebaseData.fromRTDB(Map<String, dynamic> data) {
    return FirebaseData(
        pointName: data['pointName'] ?? "",
        pointId: data['pointId'] ?? '',
        eliteName: data['eliteName'] ?? "",
        rewpawnTime: data['respawnTime'] ?? 0,
        pointIndex: data['pointIndex']);
  }
}
