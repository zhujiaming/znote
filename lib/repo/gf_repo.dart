import 'package:znote/comm/apis.dart';
import 'package:znote/config.dart';
import 'package:znote/comm/http_client.dart';
import 'package:znote/repo/base_repo.dart';

class GfRepo extends BaseRepo{
  requestToken() {
    HttpClient.post(Apis.authToken, data: {
      'grant_type': 'password',
      'username': Config.userName,
      'password': Config.password,
      'client_id': Config.clientId,
      'client_secret': Config.clientSecret,
      'scope': Config.scope
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
  }

}