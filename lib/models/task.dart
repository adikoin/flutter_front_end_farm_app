class Task {
  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.rewardAmount,
    required this.host,
    required this.path,
    required this.status,
  });
  String id, title, subtitle, icon, status, host, path;
  int rewardAmount;
  // DateTime? lastFarmStartTime;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      rewardAmount: json['rewardAmount'],
      host: json['host'],
      path: json['path'],
      status: json['status'],
    );
  }
}
