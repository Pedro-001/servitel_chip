enum STATUS{
  LOADING,
  READY
}

class StatusLoader{

  STATUS status;
  dynamic data;

  StatusLoader({this.status, this.data});

}