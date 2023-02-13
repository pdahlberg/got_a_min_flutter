
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/dto/producer_dto.dart';
import 'package:got_a_min_flutter/domain/dto/resource_dto.dart';
import 'package:got_a_min_flutter/domain/dto/storage_dto.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';

abstract class SolanaServicePort {

  initLocation(Location location);

  initProducer(Producer producer);

  produce(Producer producer, Storage storage);

  initResource(Resource resource);

  initStorage(Storage storage);

  Future<LocationDto> fetchLocationAccount(Location location);

  Future<ProducerDto> fetchProducerAccount(Producer producer);

  Future<ResourceDto> fetchResourceAccount(Resource resource);

  Future<StorageDto> fetchStorageAccount(Storage storage);

  Future<int> averageSlotTime();

  Future<void> devAirdrop(ItemId id);

}