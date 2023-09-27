import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeSixtyDegreePage extends StatefulWidget {
  const ThreeSixtyDegreePage({super.key});

  @override
  State<ThreeSixtyDegreePage> createState() => _ThreeSixtyDegreePageState();
}

class _ThreeSixtyDegreePageState extends State<ThreeSixtyDegreePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: () => locator<NavigationService>().pop(), icon: const Icon(Icons.close)),
      ),
      body: const Center(
        child: ModelViewer(
          src: 'assets/models/gold.glb',
          ar: false,
          cameraControls: true,
          autoRotate: true,
          disableZoom: false,
          xrEnvironment: true,
          arPlacement: ArPlacement.wall,
          disableTap: true,
          autoPlay: false,
          debugLogging: false,
          disablePan: false,
          loading: Loading.eager,
          // orientation: '75deg',
        ),
      ),
    );
  }
}
