class treatement {
  String? _id;
  DateTime? _datetreat;
  String? _dent;
  String? _natureinterv;
  String?_notes;

  String? get notes => _notes;

  set notes(String? value) {
    _notes = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  int? _doit;
  int? _recu;

  treatement(this._id,this._datetreat, this._dent, this._natureinterv,this._notes, this._doit, this._recu,);

  DateTime? get datetreat => _datetreat;

  set datetreat(DateTime? value) {
    _datetreat = value;
  }

  String? get dent => _dent;

  set dent(String? value) {
    _dent = value;
  }

  String? get natureinterv => _natureinterv;

  set natureinterv(String? value) {
    _natureinterv = value;
  }

  int? get doit => _doit;

  set doit(int? value) {
    _doit = value;
  }

  int? get recu => _recu;

  set recu(int? value) {
    _recu = value;
  }
}