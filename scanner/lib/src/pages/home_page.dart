import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanner/src/block/scan_block.dart';
import 'package:scanner/src/models/scan_model.dart';
import 'package:scanner/src/pages/direcciones_page.dart';
import 'package:scanner/src/pages/mapas_page.dart';
import 'package:scanner/src/providers/db_provider.dart';
import 'package:scanner/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottonNavigatorBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future _scanQR(BuildContext context) async {
    //geo:40.724233047051705,-74.00731459101564
    String futureString = 'https://fernando-herrera.com';

    /* var camStatus = await Permission.camera.status;
    var photoStatus = await Permission.photos.status;

    var camPerm = camStatus.isUndetermined ? null : camStatus.isGranted;
    var photoPerm = photoStatus.isUndetermined ? null : photoStatus.isGranted;
    try {
      futureString = await tryOpenScanner(context,
          hvCameraPerm: camPerm, hvPhotoPerm: photoPerm);
      print("esta entrand $futureString");
    } catch (e) {
      //  futureString = e.toString();
    }*/

    // print('futureStirng: $futureString');

    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      final scan2 =
          ScanModel(valor: 'geo:7.800903901268074, -72.22785557296274');
      scansBloc.agregarScan(scan2);
      if (Platform.isAndroid) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }
    }
  }

  Widget _crearBottonNavigatorBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: "mapas",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          label: "direcciones",
        ),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return Text("no funciona");
      case 1:
        return DireccionPage();

      default:
        return MapasPage();
    }
  }
}
