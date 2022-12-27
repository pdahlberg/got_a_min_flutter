
import 'package:got_a_min_flutter/domain/model/item.dart';

class LocationDto {

  final bool initialized;
  final String name;
  final String owner;
  final int occupiedSpace;
  final int capacity;
  final int position;

  LocationDto(
    this.initialized,
    this.name,
    this.owner,
    this.occupiedSpace,
    this.capacity,
    this.position,
  );

  Item updateByCopy(Item item) {
    assert(item.owner?.keyPair.publicKey.toBase58() == owner);

    return item.copyWith(
      initialized: initialized,
      name: name,
    );
  }

}