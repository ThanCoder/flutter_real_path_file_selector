import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'real_path_file_selector_platform_interface.dart';

/// An implementation of [RealPathFileSelectorPlatform] that uses method channels.
class MethodChannelRealPathFileSelector extends RealPathFileSelectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('real_path_file_selector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
