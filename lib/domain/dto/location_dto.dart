
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/location_type.dart';

class LocationDto {

  final bool initialized;
  final String name;
  final String owner;
  final int occupiedSpace;
  final int capacity;
  final int posX;
  final int posY;
  final int locationType;

  LocationDto(
    this.initialized,
    this.name,
    this.owner,
    this.occupiedSpace,
    this.capacity,
    this.posX,
    this.posY,
    this.locationType,
  );

  LocationType getLocationType() {
    switch(locationType) {
      case 0: return LocationType.unexplored;
      //case 1: return LocationType.space;
      default: return LocationType.space;
    }
  }


}