
import 'package:servitel_chip/src/data/phone_recharges_data_source.dart';

class PhoneRechargesRepository{

  final PhoneRechargesDataSource _phoneRechargesDataSource;

  const PhoneRechargesRepository(this._phoneRechargesDataSource);

  Future recharge(String phone, String latitud, String longitud, String firma) =>
    _phoneRechargesDataSource.recharge(phone, latitud, longitud, firma);

  Future record(String startDate, String endDate, String firma) =>
      _phoneRechargesDataSource.record(startDate, endDate, firma);

  Future childrens(String firma) => _phoneRechargesDataSource.childrens(firma);

  Future transfers(String firma, String idHijo, String lineaTransferir) => _phoneRechargesDataSource.transfers(idHijo, lineaTransferir, firma);
}