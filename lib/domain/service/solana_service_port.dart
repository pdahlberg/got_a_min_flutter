
import 'package:got_a_min_flutter/domain/dto/game_map_dto.dart';
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/dto/producer_dto.dart';
import 'package:got_a_min_flutter/domain/dto/resource_dto.dart';
import 'package:got_a_min_flutter/domain/dto/storage_dto.dart';
import 'package:got_a_min_flutter/domain/dto/unit_dto.dart';
import 'package:got_a_min_flutter/domain/model/game.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/model/unit.dart';

abstract class SolanaServicePort {

  initLocation(Location location);

  initProducer(Producer producer);

  initResource(Resource resource);

  initStorage(Storage storage);

  initMap(GameMap map);

  initUnit(Unit unit);

  Future<ItemId> unitPda(Player player, String unitName);

  produce(Producer producer, Storage storage);

  Future<LocationDto> fetchLocationAccount(Location location);

  Future<ProducerDto> fetchProducerAccount(Producer producer);

  Future<ResourceDto> fetchResourceAccount(Resource resource);

  Future<StorageDto> fetchStorageAccount(Storage storage);

  Future<GameMapDto> fetchMapAccount(GameMap map);

  Future<UnitDto> fetchUnitAccount(Unit unit);

  Future<int> averageSlotTime();

  Future<void> devAirdrop(ItemId id);

  Future<Game> getGame();

}