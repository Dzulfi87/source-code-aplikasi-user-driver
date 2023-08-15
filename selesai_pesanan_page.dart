import 'dart:io';

import 'package:driver_angkutan_sayur/data/constants/assets_constant.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/selesai_pesanan/selesai_pesanan_bloc.dart';
import 'package:driver_angkutan_sayur/presentation/statemanagement/bloc/selesai_pesanan/selesai_pesanan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelesaiPesananPage extends StatelessWidget {
  const SelesaiPesananPage({super.key, required this.faktur});
  final String faktur;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelesaiPesananBloc(),
      child: SelesaiPesananPageImpl(
        faktur: faktur,
      ),
    );
  }
}

class SelesaiPesananPageImpl extends StatefulWidget {
  const SelesaiPesananPageImpl({super.key, required this.faktur});
  final String faktur;
  @override
  State<SelesaiPesananPageImpl> createState() => _SelesaiPesananPageImplState();
}

class _SelesaiPesananPageImplState extends State<SelesaiPesananPageImpl> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        title: Text("Selesai Pesanan"),
      ),
      body: ListView(
        children: [
          Text("Upload Bukti*"),
          SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () =>
                context.read<SelesaiPesananBloc>().onChooseImageBukti(),
            child: BlocBuilder<SelesaiPesananBloc, SelesaiPesananState>(
              builder: (context, state) {
                if (state is ImageBuktiTerpilihState) {
                  imageFile = state.imageFile;
                }
                return imageFile == null
                    ? Image.asset(AssetsConstant.imgEmpty)
                    : Image.file(imageFile!);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        child: BottomAppBar(
          child: BlocBuilder<SelesaiPesananBloc, SelesaiPesananState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is! InitState
                    ? () => context
                        .read<SelesaiPesananBloc>()
                        .onSelesai(widget.faktur, imageFile!.path)
                    : null,
                child: Text(
                    state is! InitState ? "Selesai" : "Mohon upload gambar"),
              );
            },
          ),
        ),
      ),
    );
  }
}
