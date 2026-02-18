class LGConfig {
  final String ip;
  final int port;
  final String username;
  final String password;
  final int screens;

  LGConfig({
    required this.ip,
    required this.port,
    required this.username,
    required this.password,
    required this.screens,
  });

  Map<String, dynamic> toJson() => {
    'ip': ip,
    'port': port,
    'username': username,
    'password': password,
    'screens': screens,
  };

  factory LGConfig.fromJson(Map<String, dynamic> json) => LGConfig(
    ip: json['ip'],
    port: json['port'],
    username: json['username'],
    password: json['password'],
    screens: json['screens'],
  );
}
