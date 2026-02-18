import 'package:flutter_lg_starter_kit/services/lg_service.dart';

class KMLService {
  final LGService lgService;

  KMLService(this.lgService);

  String generatePoint(double lat, double lng, String name) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Placemark>
    <name>$name</name>
    <Point>
      <coordinates>$lng,$lat,0</coordinates>
    </Point>
  </Placemark>
</kml>''';
  }

  String generatePolygon(
    List<List<double>> coordinates,
    String name, {
    bool is3D = true,
    double altitude = 100,
  }) {
    String coordString = coordinates
        .map((c) => '${c[1]},${c[0]},$altitude')
        .join(' ');
    // Close the polygon by repeating the first coordinate
    coordString += ' ${coordinates[0][1]},${coordinates[0][0]},$altitude';

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Placemark>
    <name>$name</name>
    <styleUrl>#m_ylw-pushpin</styleUrl>
    <Polygon>
      <extrude>${is3D ? 1 : 0}</extrude>
      <tessellate>1</tessellate>
      <altitudeMode>${is3D ? 'relativeToGround' : 'clampToGround'}</altitudeMode>
      <outerBoundaryIs>
        <LinearRing>
          <coordinates>$coordString</coordinates>
        </LinearRing>
      </outerBoundaryIs>
    </Polygon>
  </Placemark>
</kml>''';
  }

  Future<void> sendKML(String content, {String name = 'query.kml'}) async {
    await lgService.sendKML(content, name: name);
  }
}
