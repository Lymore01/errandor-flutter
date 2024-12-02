import 'package:errandor/models/user.dart';

class Errand {
  final String id;
  final User belongsTo;
  final String name;
  final String? errandImage;
  final String description;
  final String county;
  final String subCounty;
  final double reward;
  final String place;
  final DateTime dateTime;
  final DateTime completionTime;
  final String urgency;
  final String instructions;
  final String status;
  final List<String> claimedErrandor;
  final String? approvedErrandor;
  final DateTime createdAt;
  final DateTime updatedAt;


  Errand({
    required this.id,
    required this.belongsTo,
    required this.name,
    this.errandImage,
    required this.description,
    required this.county,
    required this.subCounty,
    required this.reward,
    required this.place,
    required this.dateTime,
    required this.completionTime,
    required this.urgency,
    required this.instructions,
    required this.status,
    required this.claimedErrandor,
    this.approvedErrandor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Errand.fromJson(Map<String, dynamic> json) {
    return Errand(
      id: json['_id'] ?? '',
      belongsTo: User.fromJson(json['belongsTo'] ?? {}),
      name: json['errandName'] ?? '',
      errandImage: json['errandImage'],
      description: json['description'] ?? '',
      county: json['county'] ?? '',
      subCounty: json['subCounty'] ?? '',
      reward: (json['reward'] ?? 0).toDouble(),
      place: json['place'] ?? '',
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      completionTime: DateTime.parse(json['completionTime'] ?? DateTime.now().toIso8601String()),
      urgency: json['urgency'] ?? 'Low',
      instructions: json['instructions'] ?? '',
      status: json['status'] ?? 'Pending',
      claimedErrandor: List<String>.from(json['claimedErrandor'] ?? []),
      approvedErrandor: json['approvedErrandor'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
} 