import 'package:driver_angkutan_sayur/component/func.dart';
import 'package:driver_angkutan_sayur/data/constants/color_constant.dart';
import 'package:driver_angkutan_sayur/data/model/transaksi_histori_model.dart';
import 'package:driver_angkutan_sayur/presentation/pages/home/booking/lacak_pesanan_page.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/histori/histori_bloc.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/histori/histori_state.dart';
import 'package:driver_angkutan_sayur/presentation/widgets/dash_line.dart';
import 'package:driver_angkutan_sayur/presentation/widgets/ticket_clip2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<TransaksiHistoriModel> list = [];

  Widget _statusPengiriman(String status) {
    if (status == "SELESAI") {
      return TextButton(
          onPressed: () {}, child: const Text("Bukti Pengiriman"));
    } else if (status == "DALAM PERJALANAN") {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsConstant.green, // Background color
          ),
          onPressed: () {
            Func.navigatorHelper.push(const LacakPesananPage());
          },
          child: const Text("Lacak Pengiriman"));
    } else {
      return Center(child: Text(status));
    }
  }

  @override
  Widget build(BuildContext c) {
    return BlocProvider(
      create: (_) => HistoriBloc()..onLoadHistori(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("History"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: BlocBuilder<HistoriBloc, HistoriState>(
            builder: (context, state) {
              if (state is LoadHistoriState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                list.clear();
                list.addAll((state as HistoriLoadedState).listTransaksi);
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    TransaksiHistoriModel transaksiHistoriModel = list[index];
                    return ClipPath(
                      clipper: CustomTicketShape(),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child:
                                            Text(transaksiHistoriModel.asal)),
                                    const SizedBox(
                                      width: 17,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Text(
                                          transaksiHistoriModel.tujuan,
                                          textAlign: TextAlign.end,
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    transaksiHistoriModel.catatanAlamat ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    transaksiHistoriModel.namaBarang,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Text(
                                            transaksiHistoriModel.layanan)),
                                    const SizedBox(
                                      width: 17,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Text(
                                          transaksiHistoriModel.tanggal,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const DashLine(
                                color: ColorsConstant.greenLight,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: _statusPengiriman(
                                      transaksiHistoriModel.status))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
