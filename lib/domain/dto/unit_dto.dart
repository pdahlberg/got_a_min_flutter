


class UnitDto {

  final bool initialized;
  final String owner;
  final String atLocationId;
  final String name;
  final int movementSpeed;
  final int arrivesAt;

  UnitDto(
    this.initialized,
    this.owner,
    this.atLocationId,
    this.name,
    this.movementSpeed,
    this.arrivesAt,
  );

  @override
  String toString() {
    return 'UnitDto{initialized: $initialized, owner: $owner, atLocationId: $atLocationId, name: $name, movementSpeed: $movementSpeed, arrivesAt: $arrivesAt}';
  }
}