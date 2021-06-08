import 'package:tes_1234/KaryawanModel.dart';
import 'package:path/path.dart';
import 'package:tes_1234/MySqflite.dart';


class MySqflite {
  static final _databaseName = "MyDatabase.db";
  static final _databaseV1 = 1;
  static final tableKaryawan = 'karyawan';

  static final columnNomor = '';
  static final columnNama = 'nama';
  static final columnBagian = 'bagian';
  static final columnKode = 'kode';

  // make this a singleton class
  MySqflite._privateConstructor();

  static final MySqflite instance = MySqflite._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(path, version: _databaseV1,
        onCreate: (db, version) async {
          var batch = db.batch();
          _onCreateTableKaryawan(batch);

          await batch.commit();
        });
  }

  void _onCreateTableKaryawan(Batch batch) async {
    batch.execute('''
          CREATE TABLE $tableKaryawan (
            $columnNomor TEXT PRIMARY KEY,
            $columnNama TEXT,
            $columnBagian TEXT,
            $columnKode INTEGER
          )
          ''');
  }

  ///TABLE karyawan
  Future<int> insertKaryawan(KaryawanModel model) async {
    var row = {
      columnNomor: model.nomor,
      columnNama: model.nama,
      columnBagian: model.bagian,
      columnKode: model.kode
    };

    Database db = await instance.database;
    return await db.insert(tableKaryawan, row);
  }

  Future<List<KaryawanModel>> getKaryawan() async {
    Database db = await instance.database;
    var allData = await db.rawQuery("SELECT * FROM $tableKaryawan");

    List<KaryawanModel> result = [];
    for (var data in allData) {
      result.add(KaryawanModel(
          nomor : data[columnNomor],
          nama: data[columnNama],
          bagian: data[columnBagian],
          kode: int.parse(data[columnKode].toString())));
    }

    return result;
  }

  Future<KaryawanModel> getKaryawanByNomor(String nomor) async {
    Database db = await instance.database;
    var allData = await db.rawQuery(
        "SELECT * FROM $tableKaryawan WHERE $columnNomor = $columnNomor LIMIT 1");

    if (allData.isNotEmpty) {
      return KaryawanModel(
          nomor: allData[0][columnNomor],
          nama: allData[0][columnNama],
          bagian: allData[0][columnBagian],
          kode: int.parse(allData[0][columnKode]));
    } else {
      return null;
    }
  }

  Future<int> updateMahasiswaDepartment(KaryawanModel model) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE $tableKaryawan SET $columnBagian = ${model.bagian} '
            'Where $columnNomor = ${model.nomor');
  }

  Future<int> deleteKaryawan(String nomor) async {
    Database db = await instance.database;
    return await db
        .rawDelete('DELETE FROM $tableKaryawan Where $columnNomor = $nomor');
  }

  clearAllData() async {
    Database db = await instance.database;
    await db.rawQuery("DELETE FROM $tableKaryawan");
  }
}