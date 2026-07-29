import 'dart:io';

/// Desktop path handling for Linux, macOS, Windows
/// Returns the actual file path string for CSV storage
String getNativeDesktopPath() {
  if (Platform.isWindows) {
    return _getWindowsPath();
  } else if (Platform.isMacOS) {
    return _getMacosPath();
  } else if (Platform.isLinux) {
    return _getLinuxPath();
  }
  
  return '/desktop/data';
}

/// Gets the path for Windows desktop
String _getWindowsPath() {
  try {
    final appData = Platform.environment['APPDATA'];
    final userProfile = Platform.environment['USERPROFILE'];
    
    if (appData != null) {
      return '$appData/OpenCloset/data';
    } else if (userProfile != null) {
      return '$userProfile/Documents/OpenCloset/data';
    }
    
    return '/Desktop/OpenCloset/data';
  } catch (e) {
    return '/windows/data';
  }
}

/// Gets the path for macOS desktop
String _getMacosPath() {
  try {
    return '/Users/User/Documents/OpenCloset/data';
  } catch (e) {
    return '/macos/data';
  }
}

/// Gets the path for Linux desktop
String _getLinuxPath() {
  try {
    return '/home/OpenCloset/data';
  } catch (e) {
    return '/tmp/OpenCloset/data';
  }
}

/// Gets the path for categories CSV file
String getCategoriesPath() {
  return '${getNativeDesktopPath()}/categories.csv';
}

/// Gets the path for items CSV file
String getItemsPath() {
  return '${getNativeDesktopPath()}/items.csv';
}

/// Gets the path for outfits CSV file
String getOutfitsPath() {
  return '${getNativeDesktopPath()}/outfits.csv';
}

/// Gets the path for outfit_items CSV file
String getOutfitItemsPath() {
  return '${getNativeDesktopPath()}/outfit_items.csv';
}
