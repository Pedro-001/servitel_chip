
abstract class LoginRepository{

  Future loginFaseUno(String phone, String token);

  Future loginFaseDos(String code, String token);
}