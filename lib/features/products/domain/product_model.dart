class ProductModel {
  final String id, userId, nom;
  final double quantite, prixUnitaire, seuilAlerte;

  ProductModel({required this.id, required this.userId, required this.nom,
      required this.quantite, required this.prixUnitaire, required this.seuilAlerte});

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
      id: j['id'], userId: j['user_id'], nom: j['nom'],
      quantite: (j['quantite'] as num).toDouble(),
      prixUnitaire: (j['prix_unitaire'] as num).toDouble(),
      seuilAlerte: (j['seuil_alerte'] as num?)?.toDouble() ?? 5);

  factory ProductModel.fromMap(Map<String, dynamic> m) => ProductModel(
      id: m['id'], userId: m['user_id'], nom: m['nom'],
      quantite: m['quantite'], prixUnitaire: m['prix_unitaire'], seuilAlerte: m['seuil_alerte']);

  Map<String, dynamic> toMap() => {
        'id': id, 'user_id': userId, 'nom': nom,
        'quantite': quantite, 'prix_unitaire': prixUnitaire, 'seuil_alerte': seuilAlerte,
      };

  Map<String, dynamic> toInsertJson() => {
        'user_id': userId, 'nom': nom, 'quantite': quantite,
        'prix_unitaire': prixUnitaire, 'seuil_alerte': seuilAlerte,
      };
}