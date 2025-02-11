import 'package:geocoding/geocoding.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/location/domain/models/zone_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/location/domain/repositories/location_repository_interface.dart';
import 'package:sixam_mart/util/app_constants.dart';

class LocationRepository implements LocationRepositoryInterface {
  final ApiClient apiClient;

  LocationRepository({required this.apiClient});

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String address = 'Unknown Location Found';
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        address = placemarks.first.street.toString();
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
    return address;
  }

  @override
  Future<ZoneResponseModel> getZone(String? lat, String? lng,
      {bool handleError = false}) async {
    Response response = await apiClient.getData(
        '${AppConstants.zoneUri}?lat=$lat&lng=$lng',
        handleError: handleError);
    if (response.statusCode == 200) {
      ZoneResponseModel responseModel;
      List<int>? zoneIds = ZoneModel.fromJson(response.body).zoneIds;
      List<ZoneData>? zoneData = ZoneModel.fromJson(response.body).zoneData;
      responseModel =
          ZoneResponseModel(true, '', zoneIds ?? [], zoneData ?? [], []);
      return responseModel;
    } else {
      return ZoneResponseModel(false, response.statusText, [], [], []);
    }
  }

  @override
  Future<Response> searchLocation(String text) async {
    return await apiClient
        .getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(String? id) async {
    Response response =
        await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$id');
    return response;
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
