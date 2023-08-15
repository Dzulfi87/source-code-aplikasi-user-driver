import 'package:driver_angkutan_sayur/component/func.dart';
import 'package:driver_angkutan_sayur/data/constants/color_constant.dart';
import 'package:driver_angkutan_sayur/data/model/direction_map_model.dart';
import 'package:driver_angkutan_sayur/data/model/notification_model.dart';
import 'package:driver_angkutan_sayur/presentation/pages/home/booking/selesai_pesanan_page.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/navigation/navigation_bloc.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/navigation/navigation_state.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/selesai_pesanan/selesai_pesanan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class NavigasiPage extends StatelessWidget {
  const NavigasiPage({super.key, required this.notificationModel});
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: NavigasiPageImpl(notificationModel: notificationModel),
    );
  }
}

class NavigasiPageImpl extends StatefulWidget {
  const NavigasiPageImpl({super.key, required this.notificationModel});
  final NotificationModel notificationModel;
  @override
  State<NavigasiPageImpl> createState() => _NavigasiPageImpl();
}

class _NavigasiPageImpl extends State<NavigasiPageImpl> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.983908, 112.621391),
    zoom: 14.4746,
  );
  late GoogleMapController mapController;
  late DirectionsModel directionsModel;
  Set<Polyline> polylines = {};
  Set<Marker> markersDirection = {};
  Set<Marker> markers = {};
  BitmapDescriptor driverIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  void _setMapFitToTour(Set<Polyline> p) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    for (var poly in p) {
      for (var point in poly.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      }
    }
    mapController.moveCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }

  Future<void> generateIcon() async {
    // driverIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size(10, 10)),
    //     "assets/images/img_car.png");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    context.read<NavigationBloc>().stopLinstenDriverMove();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
    generateIcon();
    context.read<NavigationBloc>().loadDirections(
        LatLng(widget.notificationModel.latitudeAsal,
            widget.notificationModel.longitudeAsal),
        LatLng(widget.notificationModel.latitudeTujuan,
            widget.notificationModel.longitudeTujuan));
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigasi Pengiriman"),
      ),
      body: SlidingUpPanel(
        minHeight: MediaQuery.of(context).size.height * 0.16,
        panelBuilder: () {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(16)),
            ),
            child: BottomAppBar(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Informasi Pengiriman",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                  ListTile(
                    leading: const CircleAvatar(),
                    title: Text(widget.notificationModel.namaBarang),
                    subtitle: Text("Rp. ${widget.notificationModel.ongkos}"),
                    trailing: const Icon(
                      Icons.call,
                      color: ColorsConstant.green,
                    ),
                  ),
                  const Divider(
                    color: ColorsConstant.greyBorder,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.green.withOpacity(0.20),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: ColorsConstant.green,
                      ),
                    ),
                    title: const Text(
                      "Alamat tujuan",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    subtitle: Text(
                      widget.notificationModel.tujuan,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.green.withOpacity(0.20),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: ColorsConstant.green,
                      ),
                    ),
                    title: const Text(
                      "Waktu Pengantaran",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    subtitle: const Text(
                      "12 Mei 2023, 12:00",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () =>
                          Func.navigatorHelper.push(SelesaiPesananPage(
                            faktur: widget.notificationModel.faktur,
                          )),
                      child: Text("Selesai"))
                ],
              ),
            ),
          );
        },
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is LoadedDirectionsState) {
              directionsModel = state.directionsModel;
              polylines = {
                Polyline(
                  polylineId: const PolylineId('direction_polyline'),
                  color: Theme.of(context).colorScheme.primary,
                  width: 5,
                  points: directionsModel.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                )
              };
              markersDirection = {
                Marker(
                    markerId: const MarkerId("0"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(widget.notificationModel.latitudeAsal,
                        widget.notificationModel.longitudeAsal)),
                Marker(
                    markerId: const MarkerId("1"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(90),
                    position: LatLng(widget.notificationModel.latitudeTujuan,
                        widget.notificationModel.longitudeTujuan)),
                // Marker(
                //     markerId: MarkerId("3"),
                //     position: LatLng(widget.notificationModel.latitudeAsal,
                //         widget.notificationModel.longitudeAsal),
                //     icon: driverIcon)
              };
              markers = markersDirection;
              Future.delayed(const Duration(seconds: 5)).then((value) => context
                  .read<NavigationBloc>()
                  .listenDriverMove(widget.notificationModel.faktur));
            } else if (state is DriverMoveState) {
              LatLng latLng = state.latLng;
              Marker driverMarker = Marker(
                  markerId: const MarkerId("3"),
                  position: latLng,
                  icon: driverIcon);
              markers = markersDirection;
              markers.add(driverMarker);
            }
            return GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              polylines: polylines,
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                Future.delayed(const Duration(seconds: 2)).then((_) {
                  if (polylines.isNotEmpty) {
                    _setMapFitToTour(polylines);
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}
