import 'package:flutter_soloud/flutter_soloud.dart';

final SoLoud _soloud = SoLoud.instance;
final Map<String, AudioSource> _loadedSounds = {};

Future<void> initSounds() async {
  await _soloud.init();

  final soundsToPreload = [
    'SEQ_SE_DECIDE1.wav',
    'SEQ_SE_DECIDE2.wav',
    'SEQ_SE_DECIDE3.wav',
    'SEQ_SE_DECIDE5.wav',
    'SEQ_SE_SELECT1.wav',
    'SEQ_SE_CANCEL1.wav',
    'SEQ_SE_MSCL_01.wav',
    'SEQ_SE_MSCL_05.wav',
    'SEQ_SE_SYS_63.wav',
    'SEQ_SE_SYS_65.wav',
  ];

  for (final sound in soundsToPreload) {
    _loadedSounds[sound] = await _soloud.loadAsset('assets/sounds/$sound');
  }
}

Future<void> playSound({required String soundString}) async {
  if (!_loadedSounds.containsKey(soundString)) {
    _loadedSounds[soundString] = await _soloud.loadAsset(
      'assets/sounds/$soundString',
    );
  }

  await _soloud.play(_loadedSounds[soundString]!);
}
