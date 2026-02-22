import 'package:signals/signals.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class CloudReaderSettingViewModel {
  final serverUrl = signal('http://43.139.61.244:4396');
  final username = signal('');
  final password = signal('');
  final isLoggedIn = signal(false);
  final isTesting = signal(false);
  final message = signal('');

  Future<void> initSignals() async {
    serverUrl.value = await SharedPreferenceUtil.getCloudReaderServerUrl();
    username.value = await SharedPreferenceUtil.getCloudReaderUsername();
    password.value = await SharedPreferenceUtil.getCloudReaderPassword();
    var token = await SharedPreferenceUtil.getCloudReaderAccessToken();
    isLoggedIn.value = token.isNotEmpty;
  }

  Future<void> saveServerUrl(String url) async {
    serverUrl.value = url;
    await SharedPreferenceUtil.setCloudReaderServerUrl(url);
    CloudReaderApiClient().updateBaseUrl(url);
  }

  Future<void> login() async {
    try {
      message.value = '';
      await CloudReaderApiClient().loadConfig();
      CloudReaderApiClient().updateBaseUrl(serverUrl.value);
      await CloudReaderApiClient().login(username.value, password.value);
      await SharedPreferenceUtil.setCloudReaderUsername(username.value);
      await SharedPreferenceUtil.setCloudReaderPassword(password.value);
      isLoggedIn.value = true;
      message.value = '登录成功';
    } catch (e) {
      message.value = '登录失败: $e';
    }
  }

  Future<void> logout() async {
    await SharedPreferenceUtil.setCloudReaderAccessToken('');
    CloudReaderApiClient().updateAccessToken('');
    isLoggedIn.value = false;
    message.value = '已登出';
  }

  Future<void> testConnection() async {
    isTesting.value = true;
    message.value = '';
    try {
      CloudReaderApiClient().updateBaseUrl(serverUrl.value);
      await CloudReaderApiClient().loadConfig();
      await CloudReaderApiClient().getBookshelf();
      message.value = '连接成功';
    } catch (e) {
      message.value = '连接失败: $e';
    } finally {
      isTesting.value = false;
    }
  }
}
