class Business {
  const Business({
    required this.id,
    required this.accountId,
    required this.userId,
    required this.ruc,
    required this.pictureUrl,
    required this.picturePublicId,
    required this.companyName,
    required this.mainLocation,
  });

  final String id;
  final String accountId;
  final String userId;
  final String ruc;
  final String pictureUrl;
  final String picturePublicId;
  final String companyName;
  final String mainLocation;
}
