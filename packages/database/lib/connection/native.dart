import 'dart:io';

/// Native path handling for mobile platforms (iOS, Android)
/// Returns the actual file path string for CSV storage
String getNativeMobilePath() {
  try {
    // Use system temp directory as fallback for mobile
    return Directory.systemTemp.path;
  } catch (e) {
    return '/mobile/app/documents';
  }
}

/// Gets the path for categories CSV file
String getCategoriesPath() {
  return '${getNativeMobilePath()}/OpenCloset/data/categories.csv';
}

/// Gets the path for items CSV file
String getItemsPath() {
  return '${getNativeMobilePath()}/OpenCloset/data/items.csv';
}

/// Gets the path for outfits CSV file
String getOutfitsPath() {
  return '${getNativeMobilePath()}/OpenCloset/data/outfits.csv';
}

/// Gets the path for outfit_items CSV file
String getOutfitItemsPath() {
  return '${getNativeMobilePath()}/OpenCloset/data/outfit_items.csv';
}
