// import 'package:geolocator/geolocator.dart';

// /// Represents the different states of location service
// enum LocationStatus {
//   initial,      // Not yet requested
//   loading,      // Currently acquiring location
//   available,    // Location data available
//   serviceDisabled,  // Location service is turned off
//   permissionDenied, // Permission denied by user
//   permissionDeniedForever, // Permission permanently denied
//   error,        // Other errors
// }

// /// Manages location state with status and data
// class LocationState {
//   final LocationStatus status;
//   final Position? position;
//   final String? errorMessage;

//   const LocationState({
//     required this.status,
//     this.position,
//     this.errorMessage,
//   });

//   /// Initial state
//   const LocationState.initial()
//       : status = LocationStatus.initial,
//         position = null,
//         errorMessage = null;

//   /// Loading state
//   const LocationState.loading()
//       : status = LocationStatus.loading,
//         position = null,
//         errorMessage = null;

//   /// Success state with position
//   const LocationState.available(Position this.position)
//       : status = LocationStatus.available,
//         errorMessage = null;

//   /// Service disabled state
//   const LocationState.serviceDisabled()
//       : status = LocationStatus.serviceDisabled,
//         position = null,
//         errorMessage = 'Location service is disabled';

//   /// Permission denied state
//   const LocationState.permissionDenied()
//       : status = LocationStatus.permissionDenied,
//         position = null,
//         errorMessage = 'Location permission denied';

//   /// Permission permanently denied state
//   const LocationState.permissionDeniedForever()
//       : status = LocationStatus.permissionDeniedForever,
//         position = null,
//         errorMessage = 'Location permission permanently denied';

//   /// Error state
//   const LocationState.error(String this.errorMessage)
//       : status = LocationStatus.error,
//         position = null;

//   /// Check if location is available
//   bool get isAvailable => status == LocationStatus.available && position != null;

//   /// Check if currently loading
//   bool get isLoading => status == LocationStatus.loading;

//   /// Check if can request permission
//   bool get canRequestPermission =>
//       status == LocationStatus.serviceDisabled ||
//       status == LocationStatus.permissionDenied ||
//       status == LocationStatus.initial;

//   /// Check if should show enable button
//   bool get shouldShowEnableButton =>
//       status != LocationStatus.available && status != LocationStatus.loading;

//   @override
//   String toString() =>
//       'LocationState(status: $status, hasPosition: ${position != null}, error: $errorMessage)';
  
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is LocationState &&
//         other.status == status &&
//         other.position == position &&
//         other.errorMessage == errorMessage;
//   }

//   @override
//   int get hashCode => status.hashCode ^ position.hashCode ^ errorMessage.hashCode;
// }