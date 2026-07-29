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
  return '/mobile/app/documents/OpenCloset/data';
}

/// Gets the storage path for desktop platforms (Linux, macOS, Windows)
String _getDesktopPath() {
  if (Platform.isWindows) {
    // Windows: Use APPDATA or USERPROFILE
    final appData = Platform.environment['APPDATA'];
    final userProfile = Platform.environment['USERPROFILE'];
    
    if (appData != null) {
      return '$appData/OpenCloset/data';
    } else if (userProfile != null) {
      return '$userProfile/OpenCloset/data';
    }
    return '/data/OpenCloset/data';
  } else if (Platform.isMacOS) {
    // macOS: Use Documents folder
    return '${Platform.environment['HOME'] ?? ''}/Documents/OpenCloset/data';
  } else if (Platform.isLinux) {
    // Linux: Use home directory
    return '${Platform.environment['HOME'] ?? ''}/OpenCloset/data';
  }
  return '/data/OpenCloset/data';
}

/// Gets the storage path for web platform
String _getWebPath() {
  return '/webstorage/OpenCloset/data';
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
