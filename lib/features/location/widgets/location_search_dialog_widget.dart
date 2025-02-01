import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSearchDialogWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  final bool? isPickedUp;
  final bool isRider;
  final bool isFrom;
  const LocationSearchDialogWidget({super.key, required this.mapController, this.isPickedUp, this.isRider = false, this.isFrom = false});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      width: 500,
      margin: EdgeInsets.only(
        top: ResponsiveHelper.isDesktop(context) ? 180 : 0,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: SizedBox(width: ResponsiveHelper.isDesktop(context) ? 600 : Dimensions.webMaxWidth, child: TypeAheadField(
          controller: controller,
          suggestionsCallback: (pattern) async {
            return await Get.find<LocationController>().searchLocation(context, pattern);
          },
          itemBuilder: (context, PredictionModel suggestion) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [
                const Icon(Icons.location_on),
                Expanded(
                  child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                  )),
                ),
              ]),
            );
          },
          onSelected: (PredictionModel suggestion) {
            if(isRider){
              Get.find<RiderController>().setLocationFromPlace(suggestion.placeId, suggestion.description, isFrom);
            }else {
              if(isPickedUp == null) {
                Get.find<LocationController>().setLocation(suggestion.placeId, suggestion.description, mapController);
              }else {
                Get.find<ParcelController>().setLocationFromPlace(suggestion.placeId, suggestion.description, isPickedUp);
              }
            }
            Get.back();
          },
        )),
      ),
    );
  }
}
