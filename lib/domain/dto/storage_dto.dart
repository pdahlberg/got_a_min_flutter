
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/mobility_type.dart';

class StorageDto {

  final bool initialized;
  final String owner;
  final int amount;
  final int capacity;
  final int mobilityType;

  StorageDto(
    this.initialized,
    this.owner,
    this.amount,
    this.capacity,
    this.mobilityType
  );

  MobilityType getMobilityType() {
    switch(mobilityType) {
      case 0: return MobilityType.fixed;
      case 1: return MobilityType.movable;
      default: return MobilityType.fixed;
    }
  }

}