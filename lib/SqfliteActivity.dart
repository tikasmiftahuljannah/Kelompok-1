import 'package:tes_1234/KaryawanModel.dart';
import 'package:tes_1234/MySqflite.dart';
import 'package:flutter/material.dart';

class SqfliteActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SqfliteActivityState();
}

class SqfliteActivityState extends State<SqfliteActivity> {
  final keyFormKaryawan = GlobalKey<FormState>();

  TextEditingController controllerNomor = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerBagian = TextEditingController();
  TextEditingController controllerKode = TextEditingController();

  String nomor = "";
  String nama = "";
  String bagian = "";
  int kode = 0;

  List<KaryawanModel> karyawan = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      karyawan = await MySqflite.instance.getKaryawan();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 36, left: 24, bottom: 4),
              child: Text("Input Karyawan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Form(
              key: keyFormKaryawan,
              child: Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerNomor,
                      decoration: InputDecoration(hintText: "Nomor"),
                      validator: (value) => _onValidateText(value),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => nomor = value,
                    ),
                    TextFormField(
                      controller: controllerNama,
                      decoration: InputDecoration(hintText: "Nama"),
                      validator: (value) => _onValidateText(value),
                      onSaved: (value) => nama = value,
                    ),
                    TextFormField(
                      controller: controllerBagian,
                      decoration: InputDecoration(hintText: "bagian"),
                      validator: (value) => _onValidateText(value),
                      onSaved: (value) => bagian = value,
                    ),
                    TextFormField(
                      controller: controllerKode,
                      decoration: InputDecoration(hintText: "kode"),
                      validator: (value) => _onValidateText(value),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => kode = int.parse(value),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: RaisedButton(
                onPressed: () {
                  _onSaveKaryawan();
                },
                child: Text("Simpan"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24, left: 24, bottom: 4),
              child: Text("Data karyawan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: karyawan.length,
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                    itemBuilder: (BuildContext context, int index) {
                      var value = karyawan[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Nim: ${value.nomor}"),
                            Text("Name: ${value.nama}"),
                            Text("Department: ${value.bagian}"),
                            Text("SKS: ${value.kode}"),
                          ],
                        ),
                      );
                    }))
          ],
        ));
  }

  String _onValidateText(String value) {
    if (value.isEmpty) return 'Tidak boleh kosong';
    return null;
  }

  _onSaveMahasiswa() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (keyFormKaryawan.currentState.validate()) {
      keyFormKaryawan.currentState.save();
      controllerNomor.text = "";
      controllerNama.text = "";
      controllerBagian.text = "";
      controllerKode.text = "";

      await MySqflite.instance.insertKaryawan(karyawanModel(
          nomor: nomor, nama: nama, bagian: bagian, kode: kode));

      karyawan = await MySqflite.instance.getKaryawan();
      setState(() {});
    }
  }
}