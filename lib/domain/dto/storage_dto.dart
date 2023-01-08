
import 'package:got_a_min_flutter/domain/model/item.dart';

class StorageDto {

  final bool initialized;
  final String owner;
  final int amount;

  StorageDto(
    this.initialized,
    this.owner,
    this.amount,
  );

}