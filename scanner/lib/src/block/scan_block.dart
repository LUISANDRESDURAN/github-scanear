import 'dart:async';

import 'package:scanner/src/block/validator.dart';
import 'package:scanner/src/models/scan_model.dart';
import 'package:scanner/src/providers/db_provider.dart';

class ScansBloc with Validators {
  //patron singleton
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //obtener los scans de la base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

//obtener toda la informacino del scans
  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async {
    //aca ya se inserto en la base de datos
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  //borrar scans
  borrarScans(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTODOS() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}
