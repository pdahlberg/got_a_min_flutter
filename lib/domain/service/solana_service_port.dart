
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/dto/resource_dto.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';

abstract class SolanaServicePort {

  initLocation(Location location);

  initResource(Resource resource);

  Future<LocationDto> fetchLocationAccount(Location location);

  Future<ResourceDto> fetchResourceAccount(Resource resource);

  Future<Owner> getOwner();

}