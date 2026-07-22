/// Optional cloud synchronization.
///
/// This package provides the cloud synchronization infrastructure for
/// keeping wardrobe data consistent across multiple devices.
///
/// Key responsibilities:
/// - Cloud provider abstractions
/// - Sync conflict resolution
/// - Delta computation and transfer
/// - Offline queue management
///
/// Usage:
/// ```dart
/// import 'package:opencloset/packages/sync/lib/sync.dart';
///
/// await SyncService.connect(provider: CloudProvider.firebase);
/// ```
