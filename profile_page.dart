import 'package:driver_angkutan_sayur/component/custom_icons_icons.dart';
import 'package:driver_angkutan_sayur/component/func.dart';
import 'package:driver_angkutan_sayur/component/services/mqtt_client_service.dart';
import 'package:driver_angkutan_sayur/data/constants/color_constant.dart';
import 'package:driver_angkutan_sayur/data/constants/config_constant.dart';
import 'package:driver_angkutan_sayur/presentation/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:driver_angkutan_sayur/injection.dart' as inj;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () async {
                  await inj.locator<MQTTClientService>().connect();
                  inj
                      .locator<MQTTClientService>()
                      .subscribeFaktur("PP210623772");
                },
                leading: Icon(CustomIcons.profile),
                title: Text(
                  Func.cache.getString(ConfigConstant.nama),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  Func.cache.getString(ConfigConstant.telepon),
                  style: TextStyle(color: ColorsConstant.yellow),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              ListTile(
                onTap: () {
                  Func.cache.setString(ConfigConstant.telepon, "");
                  Func.navigatorHelper.pushAndRemoveUntil(const LoginPage());
                },
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: ColorsConstant.green.withOpacity(0.2),
                  child: ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.headphones,
                      color: ColorsConstant.green,
                    ),
                    title: Text(
                      "Butuh bantuan? Hubungi kami",
                      style: TextStyle(color: ColorsConstant.green),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
