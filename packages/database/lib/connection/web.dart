/// Web path handling for web browser platform
/// Returns the actual file path string for CSV storage

/// Gets the path for web platform
String getWebPath() {
  return '/webstorage/OpenCloset/data';
}

/// Gets the path for categories CSV file
String getCategoriesPath() {
  return '$getWebPath/categories.csv';
}

/// Gets the path for items CSV file
String getItemsPath() {
  return '$getWebPath/items.csv';
}

/// Gets the path for outfits CSV file
String getOutfitsPath() {
  return '$getWebPath/outfits.csv';
}

/// Gets the path for outfit_items CSV file
String getOutfitItemsPath() {
  return '$getWebPath/outfit_items.csv';
}
