
class Patient {

  String? _id;
  String? _pname;
  String? _plname;
  int? _telnum;
  DateTime? _daten;
  String? _adress;
  String? _proff;
  String? _ref;

  Patient(this._id,this._pname, this._plname, this._telnum, this._daten, this._adress,
      this._proff, this._ref);

  String? get ref => _ref;
  String? get id => _id;

  set id(String? value) {
    _id = value;
  }
  set ref(String? value) {
    _ref = value;
  }

  String? get proff => _proff;

  set proff(String? value) {
    _proff = value;
  }

  String? get adress => _adress;

  set adress(String? value) {
    _adress = value;
  }

  DateTime? get daten => _daten;

  set daten(DateTime? value) {
    _daten = value;
  }

  int? get telnum => _telnum;

  set telnum(int? value) {
    _telnum = value;
  }

  String? get plname => _plname;

  set plname(String? value) {
    _plname = value;
  }

  String? get pname => _pname;

  set pname(String? value) {
    _pname = value;
  }

  Patient copy() {
    return Patient(
      _id,
      _pname,
      _plname,
      _telnum,
      _daten,
      _adress,
      _proff,
      _ref,
    );
  }
}


