import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_lg_starter_kit/models/lg_config.dart';
import 'package:path_provider/path_provider.dart';

class LGService {
  SSHClient? _client;
  final LGConfig config;

  LGService(this.config);

  Future<bool> connect() async {
    try {
      final socket = await SSHSocket.connect(
        config.ip,
        config.port,
        timeout: const Duration(seconds: 5),
      );
      _client = SSHClient(
        socket,
        username: config.username,
        onPasswordRequest: () => config.password,
      );
      return true;
    } catch (e) {
      debugPrint('Connection failed: $e');
      return false;
    }
  }

  Future<void> execute(String command) async {
    if (_client == null) return;
    try {
      await _client!.run(command);
    } catch (e) {
      debugPrint('Execution failed: $e');
    }
  }

  Future<void> sendKML(String kmlContent, {String name = 'query.kml'}) async {
    if (_client == null) return;
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$name');
      await file.writeAsString(kmlContent);

      final sftp = await _client!.sftp();
      final remoteFile = await sftp.open(
        '/var/www/html/$name',
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
      );
      await remoteFile.write(file.openRead().cast());

      await execute('echo "http://localhost/$name" > /tmp/query.txt');
    } catch (e) {
      debugPrint('SFTP failed: $e');
    }
  }

  Future<void> clearKML() async {
    await execute('echo "" > /tmp/query.txt');
  }

  Future<void> flyTo(
    double lat,
    double lng,
    double zoom,
    double tilt,
    double bearing,
  ) async {
    final kml =
        '''
<LookAt>
  <longitude>$lng</longitude>
  <latitude>$lat</latitude>
  <range>$zoom</range>
  <tilt>$tilt</tilt>
  <heading>$bearing</heading>
  <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
</LookAt>''';
    await execute('echo "flytoview=$kml" > /tmp/query.txt');
  }

  void dispose() {
    _client?.close();
  }
}
