part of 'app_navigator.dart';

enum Routes {
  splash('/'),
  home('/home'),
  record('/record'),
  playback('/playback'),
  settings('/settings');

  final String path;
  const Routes(this.path);
}