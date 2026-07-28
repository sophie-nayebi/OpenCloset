import 'dart:io';

/// Platform-aware storage path resolution for OpenCloset database.
/// Returns the appropriate base path for CSV file storage based on platform.
String getStoragePath() {
  if (Platform.isIOS || Platform.isAndroid) {
    return _getMobilePath();
  } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    return _getDesktopPath();
  } else {
    return _getWebPath();
  }
}

/// Gets the storage path for mobile platforms (iOS, Android)
String _getMobilePath() {
  try {
    return '/mobile/app/documents/OpenCloset/data';
  } catch (e) {
    return '/mobile/documents/OpenCloset/data';
  }
}

/// Gets the storage path for desktop platforms (Linux, macOS, Windows)
String _getDesktopPath() {
  if (Platform.isWindows) {
    try {
      final path = Platform.environment['APPDATA'] ?? 
                     Platform.environment['USERPROFILE'] ?? '';
      return '$path/OpenCloset/data';
    } catch (e) {
      return 'C:/Users/User/OpenCloset/data';
    }
  } else if (Platform.isMacOS) {
    try {
      return '/Users/User/Documents/OpenCloset/data';
    } catch (e) {
      return '/Users/User/Documents/OpenCloset/data';
    }
  } else if (Platform.isLinux) {
    try {
      return '/home/OpenCloset/data';
    } catch (e) {
      return '/tmp/OpenCloset/data';
    }
  }
  return '/data/OpenCloset/data';
}

/// Gets the storage path for web platform
String _getWebPath() {
  try {
    return '/webstorage/OpenCloset/data';
  } catch (e) {
    return '/webstorage';
  }
}

/// Gets the path for categories CSV file
String getCategoriesPath() {
  return '${getStoragePath()}/categories.csv';
}

/// Gets the path for items CSV file
String getItemsPath() {
  return '${getStoragePath()}/items.csv';
}

/// Gets the path for outfits CSV file
String getOutfitsPath() {
  return '${getStoragePath()}/outfits.csv';
}

/// Gets the path for outfit_items CSV file
String getOutfitItemsPath() {
  return '${getStoragePath()}/outfit_items.csv';
}
