import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'real_path_file_selector_method_channel.dart';

abstract class RealPathFileSelectorPlatform extends PlatformInterface {
  /// Constructs a RealPathFileSelectorPlatform.
  RealPathFileSelectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static RealPathFileSelectorPlatform _instance = MethodChannelRealPathFileSelector();

  /// The default instance of [RealPathFileSelectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelRealPathFileSelector].
  static RealPathFileSelectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RealPathFileSelectorPlatform] when
  /// they register themselves.
  static set instance(RealPathFileSelectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
