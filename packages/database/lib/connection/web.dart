import 'dart:io';

/// Web path handling for web browser platform
/// Returns the actual file path string for CSV storage
String getNativeWebPath() {
  try {
    return '/webstorage/OpenCloset/data';
  } catch (e) {
    return '/webstorage';
  }
}

/// Gets the path for categories CSV file
String getCategoriesPath() {
  return '${getNativeWebPath()}/categories.csv';
}

/// Gets the path for items CSV file
String getItemsPath() {
  return '${getNativeWebPath()}/items.csv';
}

/// Gets the path for outfits CSV file
String getOutfitsPath() {
  return '${getNativeWebPath()}/outfits.csv';
}

/// Gets the path for outfit_items CSV file
String getOutfitItemsPath() {
  return '${getNativeWebPath()}/outfit_items.csv';
}
