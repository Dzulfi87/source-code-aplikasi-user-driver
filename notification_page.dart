import 'package:driver_angkutan_sayur/data/constants/assets_constant.dart';
import 'package:driver_angkutan_sayur/data/constants/color_constant.dart';
import 'package:driver_angkutan_sayur/data/model/notification_model.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/notification/notificatioin_state.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, this.title = "Notifikasi"})
      : super(key: key);
  final String title;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) => NotificationBloc()..loadNotification(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.title),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            print('mamama');
            if (state is InitState) {
              print('mamama 1');

              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print('mamama 2');

              List<NotificationModel> list =
                  (state as NotificationLoadedState).listNotif;
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<NotificationBloc>().loadNotification(),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (c, i) {
                      NotificationModel notificationModel = list[i];
                      return Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: i == 0 ? 16 : 0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(AssetsConstant.imgNotif),
                                const SizedBox(
                                  width: 16,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                                notificationModel.namaBarang,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text(
                                            notificationModel.tanggal,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(notificationModel.tujuan),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        notificationModel.catatanAlamat,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      notificationModel.status == "DITOLAK" ||
                                              notificationModel.status ==
                                                  "SELESAI"
                                          ? Text(notificationModel.status,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey))
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  height: 32,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<
                                                                      Color>(
                                                                  ColorsConstant
                                                                      .green),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ))),
                                                      onPressed: () => context
                                                          .read<
                                                              NotificationBloc>()
                                                          .onLeftButtonTap(
                                                              notificationModel),
                                                      child: Text(
                                                        notificationModel
                                                                    .status ==
                                                                "DALAM ANTRIAN"
                                                            ? "Terima"
                                                            : "Navigasi",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                SizedBox(
                                                  height: 32,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  ColorsConstant
                                                                      .green),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                  side: const BorderSide(color: ColorsConstant.green)))),
                                                      onPressed: () => context.read<NotificationBloc>().onRightButtonTap(notificationModel),
                                                      child: Text(notificationModel.status == "DALAM ANTRIAN" ? "Tolak" : "Selesai")),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          },
        ),
      ),
    );
  }
}
