


class ProducerDto {

  final bool initialized;
  final String owner;
  final String resourceId;
  final String locationId;
  final int productionRate;
  final int productionTime;
  final int awaitingUnits;
  final int claimedAt;

  ProducerDto(
    this.initialized,
    this.owner,
    this.resourceId,
    this.locationId,
    this.productionRate,
    this.productionTime,
    this.awaitingUnits,
    this.claimedAt,
  );

  @override
  String toString() {
    return 'ProducerDto{initialized: $initialized, owner: $owner, resourceId: $resourceId, locationId: $locationId, productionRate: $productionRate, productionTime: $productionTime, awaitingUnits: $awaitingUnits, claimedAt: $claimedAt}';
  }
}