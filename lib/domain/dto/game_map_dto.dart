
import 'package:got_a_min_flutter/domain/model/compressed_sparse_matrix.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/mobility_type.dart';
import 'package:solana/solana.dart';

class GameMapDto {

  final bool initialized;
  final ItemId id;
  final String owner;
  final List<int> row_ptrs;
  final List<int> columns;
  final List<int> values;
  final int width;
  final int height;
  final int compressed_value;

  GameMapDto(
      this.initialized,
      this.id,
      this.owner,
      this.row_ptrs,
      this.columns,
      this.values,
      this.width,
      this.height,
      this.compressed_value,
  );

  GameMap toGameMap() {
    var csm = CompressedSparseMatrix(width, height, row_ptrs, columns, values, compressed_value);
    return GameMap(id, csm.toMatrix());
  }

  @override
  String toString() {
    return 'GameMapDto{initialized: $initialized, owner: $owner, row_ptrs: $row_ptrs, columns: $columns, values: $values, width: $width, height: $height, compressed_value: $compressed_value}';
  }
}