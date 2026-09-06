class SaleModel {
  final String id, userId, produitId, client, modePaiement, createdAt;
  final double quantite, prixUnitaire, montantTotal;

  SaleModel({required this.id, required this.userId, required this.produitId,
      required this.quantite, required this.prixUnitaire, required this.montantTotal,
      required this.client, required this.modePaiement, required this.createdAt});

  factory SaleModel.fromJson(Map<String, dynamic> j) => SaleModel(
      id: j['id'], userId: j['user_id'], produitId: j['produit_id'] ?? '',
      quantite: (j['quantite'] as num).toDouble(),
      prixUnitaire: (j['prix_unitaire'] as num).toDouble(),
      montantTotal: (j['montant_total'] as num).toDouble(),
      client: j['client'] ?? '', modePaiement: j['mode_paiement'] ?? 'comptant',
      createdAt: j['created_at'] ?? '');

  factory SaleModel.fromMap(Map<String, dynamic> m) => SaleModel(
      id: m['id'], userId: m['user_id'], produitId: m['produit_id'],
      quantite: m['quantite'], prixUnitaire: m['prix_unitaire'], montantTotal: m['montant_total'],
      client: m['client'], modePaiement: m['mode_paiement'], createdAt: m['created_at']);

  Map<String, dynamic> toMap() => {
        'id': id, 'user_id': userId, 'produit_id': produitId, 'quantite': quantite,
        'prix_unitaire': prixUnitaire, 'montant_total': montantTotal,
        'client': client, 'mode_paiement': modePaiement, 'created_at': createdAt,
      };

  Map<String, dynamic> toInsertJson() => {
        'user_id': userId, 'produit_id': produitId, 'quantite': quantite,
        'prix_unitaire': prixUnitaire, 'client': client, 'mode_paiement': modePaiement,
      };
}