// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/components/target_card.dart';

class TargetSlider extends StatefulWidget {
  final GoogleMapController mapController;

  const TargetSlider({
    super.key,
    required this.targetSliderToggle,
    required this.setOfMarkers,
    required this.mapController,
  });

  final bool targetSliderToggle;
  final Set<Marker> setOfMarkers;

  @override
  State<TargetSlider> createState() => _TargetSliderState();
}

class _TargetSliderState extends State<TargetSlider> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height - 240,
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: widget.targetSliderToggle
            ? ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(9),
                children: widget.setOfMarkers.map(
                  (element) {
                    if (element.icon ==
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed)) {
                      return TargetCard(
                        markerElement: element,
                        controller: widget.mapController,
                      );
                    } else {
                      return TargetCard(
                        markerElement: element,
                        controller: widget.mapController,
                      );
                    }
                  },
                ).toList(),
              )
            : const SizedBox(
                height: 1,
                width: 1,
              ),
      ),
    );
  }
}
