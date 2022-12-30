
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

abstract class SolanaServicePort {

  initLocation(Location location);

  Future<LocationDto> fetchLocationAccount(Location location);

  Future<Owner> getOwner();

}