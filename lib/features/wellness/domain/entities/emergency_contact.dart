/// Personal or crisis helpline contact.
class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    this.relationship,
    this.isHelpline = false,
  });

  final String id;
  final String name;
  final String phone;
  final String? relationship;
  final bool isHelpline;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String?,
      isHelpline: json['isHelpline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        if (relationship != null) 'relationship': relationship,
        'isHelpline': isHelpline,
      };

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phone,
    String? relationship,
    bool? isHelpline,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      isHelpline: isHelpline ?? this.isHelpline,
    );
  }
}
