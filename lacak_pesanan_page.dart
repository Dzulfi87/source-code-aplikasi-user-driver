import 'package:driver_angkutan_sayur/data/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class LacakPesananPage extends StatelessWidget {
  const LacakPesananPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LacakPesananView();
  }
}
class LacakPesananView extends StatefulWidget {
  const LacakPesananView({Key? key}) : super(key: key);

  @override
  State<LacakPesananView> createState() => _LacakPesananViewState();
}

class _LacakPesananViewState extends State<LacakPesananView> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lacak Pengiriman"),
      ),
      body: SlidingUpPanel(
        minHeight: MediaQuery.of(context).size.height * 0.16,
        panelBuilder: (){
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(16)),
            ),
            child: BottomAppBar(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView(
                children: [
                  const SizedBox(height: 16,),
                  const Text("Informasi Supir",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22
                    ),),
                  const ListTile(
                    leading: CircleAvatar(

                    ),title: Text("Bambang Sudarho"),
                    subtitle: Text("Delivery Man"),
                    trailing: Icon(Icons.call,color: ColorsConstant.green,),
                  ),
                  const Divider(color: ColorsConstant.greyBorder,),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.green.withOpacity(0.20),
                      child: const Icon(Icons.location_on_outlined, color: ColorsConstant.green,),
                    ),
                    title: const Text("Alamat tujuan", style: TextStyle(color: Colors.grey,fontSize: 12),),
                    subtitle: const Text("Pasar Blimbing, Blimbing", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.green.withOpacity(0.20),
                      child: const Icon(Icons.location_on_outlined, color: ColorsConstant.green,),
                    ),
                    title: const Text("Waktu Pengantaran", style: TextStyle(color: Colors.grey,fontSize: 12),),
                    subtitle: const Text("12 Mei 2023, 12:00", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                  )
                ],
              ),
            ),
          );
        },
        body: const GoogleMap(
          initialCameraPosition: _kGooglePlex,
        ),
      ),
    );
  }
}

