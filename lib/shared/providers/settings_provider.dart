import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preferences/preferences_service.dart';

final settingsProvider = FutureProvider<PreferencesService>((ref) => PreferencesService.load());
