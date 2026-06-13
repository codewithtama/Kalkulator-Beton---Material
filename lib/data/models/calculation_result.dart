class MaterialRequirement {
  final String key; // Identifier for price matching (e.g., 'semen', 'pasir')
  final String name;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;

  MaterialRequirement({
    required this.key,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  }) : totalPrice = quantity * unitPrice;

  MaterialRequirement copyWith({
    String? key,
    String? name,
    double? quantity,
    String? unit,
    double? unitPrice,
  }) {
    return MaterialRequirement(
      key: key ?? this.key,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'unitPrice': unitPrice,
      };

  factory MaterialRequirement.fromJson(Map<String, dynamic> json) =>
      MaterialRequirement(
        key: json['key'] as String,
        name: json['name'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}

class CalculationResult {
  final List<MaterialRequirement> requirements;
  final double totalCost;

  CalculationResult({
    required this.requirements,
  }) : totalCost = requirements.fold(0, (sum, item) => sum + item.totalPrice);
}
