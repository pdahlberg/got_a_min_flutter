
import 'package:got_a_min_flutter/domain/model/item.dart';

class LocationDto {

  final bool initialized;
  final String name;
  final String owner;
  final int occupiedSpace;
  final int capacity;
  final int posX;
  final int posY;

  LocationDto(
    this.initialized,
    this.name,
    this.owner,
    this.occupiedSpace,
    this.capacity,
    this.posX,
    this.posY,
  );



}