class DebtModel {
  final String id, userId, client, createdAt;
  final double montant, montantRembourse;

  DebtModel({required this.id, required this.userId, required this.client,
      required this.montant, required this.montantRembourse, required this.createdAt});

  factory DebtModel.fromJson(Map<String, dynamic> j) => DebtModel(
      id: j['id'], userId: j['user_id'], client: j['client'],
      montant: (j['montant'] as num).toDouble(),
      montantRembourse: (j['montant_rembourse'] as num?)?.toDouble() ?? 0,
      createdAt: j['created_at'] ?? '');

  factory DebtModel.fromMap(Map<String, dynamic> m) => DebtModel(
      id: m['id'], userId: m['user_id'], client: m['client'],
      montant: m['montant'], montantRembourse: m['montant_rembourse'], createdAt: m['created_at']);

  Map<String, dynamic> toMap() => {
        'id': id, 'user_id': userId, 'client': client,
        'montant': montant, 'montant_rembourse': montantRembourse, 'created_at': createdAt,
      };

  Map<String, dynamic> toInsertJson() =>
      {'user_id': userId, 'client': client, 'montant': montant};
}