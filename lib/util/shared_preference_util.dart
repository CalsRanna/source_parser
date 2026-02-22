import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static Future<int> getCacheDuration() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getInt('cache_duration') ?? 8;
  }

  static Future<String> getColorSeed() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('color_seed') ?? '#FF63BBD0';
  }

  static Future<bool> getDarkMode() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getBool('dark_mode') ?? false;
  }

  static Future<bool> getDeveloperMode() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getBool('developer_mode') ?? false;
  }

  static Future<bool> getEInkMode() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getBool('e_ink_mode') ?? false;
  }

  static Future<int> getMaxConcurrent() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getInt('max_concurrent') ?? 16;
  }

  static Future<bool> getSearchFilter() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getBool('search_filter') ?? false;
  }

  static Future<String> getShelfMode() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('shelf_mode') ?? 'list';
  }

  static Future<int> getThemeId() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getInt('theme_id') ?? 0;
  }

  static Future<int> getTimeout() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getInt('timeout') ?? 30;
  }

  static Future<int> getTurningMode() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getInt('turning_mode') ?? 3;
  }

  static Future<void> setCacheDuration(int duration) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('cache_duration', duration);
  }

  static Future<void> setColorSeed(String colorSeed) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('color_seed', colorSeed);
  }

  static Future<void> setDarkMode(bool darkMode) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setBool('dark_mode', darkMode);
  }

  static Future<void> setDeveloperMode(bool enable) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setBool('developer_mode', enable);
  }

  static Future<void> setEInkMode(bool eInkMode) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setBool('e_ink_mode', eInkMode);
  }

  static Future<void> setMaxConcurrent(int maxConcurrent) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('max_concurrent', maxConcurrent);
  }

  static Future<void> setSearchFilter(bool searchFilter) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setBool('search_filter', searchFilter);
  }

  static Future<void> setShelfMode(String shelfMode) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('shelf_mode', shelfMode);
  }

  static Future<void> setThemeId(int themeId) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('theme_id', themeId);
  }

  static Future<void> setTimeout(int timeout) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('timeout', timeout);
  }

  static Future<void> setTurningMode(int turningMode) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('turning_mode', turningMode);
  }

  static Future<String> getCloudReaderShelfMode() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('cloud_reader_shelf_mode') ?? 'list';
  }

  static Future<void> setCloudReaderShelfMode(String shelfMode) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('cloud_reader_shelf_mode', shelfMode);
  }

  static Future<String> getAiBaseUrl() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('ai_base_url') ?? 'https://openrouter.ai/api/v1';
  }

  static Future<void> setAiBaseUrl(String url) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('ai_base_url', url);
  }

  static Future<String> getAiApiKey() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('ai_api_key') ?? '';
  }

  static Future<void> setAiApiKey(String key) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('ai_api_key', key);
  }

  static Future<String> getAiModel() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('ai_model') ?? 'google/gemini-2.5-pro';
  }

  static Future<void> setAiModel(String model) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('ai_model', model);
  }

  static Future<String> getCloudReaderServerUrl() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('cloud_reader_server_url') ??
        'http://43.139.61.244:4396';
  }

  static Future<void> setCloudReaderServerUrl(String url) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('cloud_reader_server_url', url);
  }

  static Future<String> getCloudReaderAccessToken() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('cloud_reader_access_token') ?? '';
  }

  static Future<void> setCloudReaderAccessToken(String token) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('cloud_reader_access_token', token);
  }

  static Future<String> getCloudReaderUsername() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('cloud_reader_username') ?? '';
  }

  static Future<void> setCloudReaderUsername(String username) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('cloud_reader_username', username);
  }

  static Future<String> getCloudReaderPassword() async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('cloud_reader_password') ?? '';
  }

  static Future<void> setCloudReaderPassword(String password) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString('cloud_reader_password', password);
  }
}
