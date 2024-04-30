class UserModel{
  String? _id;
  String? _pname;
  String? _plname;
  int? _telnum;
  DateTime? _daten;
  String? _adress;
  String? _proff;
  String? _ref;

  UserModel(this._id, this._pname, this._plname, this._telnum, this._daten,
      this._adress, this._proff, this._ref);

  toJson(){
    return {
      "firstname":_pname,
      "lastname":_plname,
      "phoneNumber":_telnum,
      "birthDate":_daten,
      "adress":_adress,
      "proffession":_proff,
      "reference":_ref
    };
  }
}