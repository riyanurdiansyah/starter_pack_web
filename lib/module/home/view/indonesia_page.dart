import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'widget/color.dart';

class IndonesiaMapPage extends StatefulWidget {
  const IndonesiaMapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IndonesiaMapPageState createState() => _IndonesiaMapPageState();
}

class Model {
  /// Initialize the instance of the [Model] class.
  const Model(this.state, this.color, this.stateCode);

  /// Represents the Australia state name.
  final String state;

  /// Represents the Australia state color.
  final Color color;

  /// Represents the Australia state code.
  final String stateCode;
}

class _IndonesiaMapPageState extends State<IndonesiaMapPage> {
  late MapShapeLayerController _controller;
  late MapShapeSource _mapSource;
  bool isLoading = true;
  List<dynamic> regions = [];
  late MapZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _loadPolygons();
    _controller = MapShapeLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
    );
    super.initState();
  }

  void _loadPolygons() async {
    // Asumsikan kamu sudah punya file GeoJSON yang di-parse di sini
    final geoJsonData =
        await DefaultAssetBundle.of(context).loadString("indonesia.json");
    final data = json.decode(geoJsonData);
    regions = data['features'];

    _mapSource = MapShapeSource.asset(
      'indonesia.json',
      shapeDataField: 'NAME_1',
      dataCount: regions.length,
      primaryValueMapper: (index) => regions[index]['properties']['NAME_1'],
      shapeColorValueMapper: (index) {
        return getColorForWilayah(regions[index]['properties']['NAME_1']);
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  String formatRegionName(String name) {
    return name.replaceAllMapped(
        RegExp(r'(?<!^)([A-Z])'), (match) => ' ${match.group(0)}');
  }

  void _onRegionTapped(int index) {
    final regionName = regions[index]['properties']['NAME_1'] ?? '';

    final coordinates = regions[index]['geometry']['coordinates'];
    if (coordinates.isNotEmpty) {
      final polygon = coordinates[0][0];
      final List<double> longitudes =
          polygon.map<double>((p) => p[0] as double).toList();
      final List<double> latitudes =
          polygon.map<double>((p) => p[1] as double).toList();

      // Menghitung pusat wilayah berdasarkan rata-rata koordinat
      final centerX = (longitudes.reduce((a, b) => a + b) / longitudes.length);
      final centerY = (latitudes.reduce((a, b) => a + b) / latitudes.length);

      // Membuat MapShapeSource untuk hanya wilayah yang dipilih
      final selectedRegionSource = MapShapeSource.asset(
        'indonesia.json',
        shapeDataField: 'NAME_1',
        dataCount: regions.length,
        primaryValueMapper: (index) => regions[index]['properties']['NAME_1'],
        shapeColorValueMapper: (index) {
          if (regions[index]['properties']['NAME_1'] == regionName) {
            return Colors.red;
          }
          return Colors.white; // Warna default untuk wilayah lainnya
        },
      );

      // Menampilkan dialog yang berisi peta wilayah yang dipilih
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: SizedBox(
              width: 400, // Sesuaikan ukuran dialog
              height: 400,
              child: SfMaps(
                layers: <MapShapeLayer>[
                  MapShapeLayer(
                    source: selectedRegionSource,
                    zoomPanBehavior: MapZoomPanBehavior(
                      enableDoubleTapZooming: false,
                      enableMouseWheelZooming: false,
                      enablePanning: false,
                      enablePinching: false,
                      showToolbar: false,
                      focalLatLng: MapLatLng(
                          centerY, centerX), // Focal LatLng diatur di sini
                      zoomLevel: 5, // Atur zoom untuk wilayah yang dipilih
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 0,
                    showDataLabels: false,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SfMaps(
        layers: <MapShapeLayer>[
          MapShapeLayer(
            controller: _controller,
            source: _mapSource,
            showDataLabels: true,
            zoomPanBehavior: _zoomPanBehavior,
            tooltipSettings: MapTooltipSettings(
                color: Colors.grey[700],
                strokeColor: Colors.white,
                strokeWidth: 2),
            strokeColor: Colors.white,
            strokeWidth: 0.6,
            shapeTooltipBuilder: (BuildContext context, int index) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formatRegionName(
                        regions[index]['properties']['NAME_1'].toString()),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            onSelectionChanged: _onRegionTapped,
            dataLabelSettings: MapDataLabelSettings(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
