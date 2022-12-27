
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

abstract class SolanaServicePort {

  init(Item item);

  Future<LocationDto> fetchLocationAccount(Item item);

  Future<Owner> getOwner();

}