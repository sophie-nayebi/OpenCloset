/// OpenCloset — Wardrobe and outfit management application.

/// This package is the entry point for the OpenCloset application.
/// It bootstraps the application, initializes providers, and configures
/// the root widget tree with routing and theming.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/app/app.dart';
///
/// void main() => runApp(const MyApp());
/// ```

/// Import app configuration and entry point.
export 'app/app.dart';
export 'app/routes.dart';
export 'app/theme.dart';

/// Import feature modules.
export 'features/wardrobe/wardrobe.dart';
export 'features/outfits/outfits.dart';
export 'features/statistics/statistics.dart';
export 'features/import_export/import_export.dart';
export 'features/sync/sync.dart';
export 'features/settings/settings_screen.dart';

/// Import shared resources.
export 'shared/constants/constants.dart';
export 'shared/widgets/widgets.dart';
export 'shared/utils/utils.dart';

/// Import provider base patterns.
export 'providers/base_async_notifier.dart';
export 'providers/base_notifier.dart';
export 'providers/static_provider.dart';
