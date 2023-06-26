import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class TicketModel {
  late int? basePrice;
  late String? category;
  late String? createdAt;
  late String? date;
  late String? destination;
  late String? discount;
  late String? id;
  late String? source;
  late String? updatedAt;
  late String? vehicleIdId;
  late List<dynamic> occupiedSeats;

  TicketModel({
    required this.basePrice,
    required this.category,
    required this.createdAt,
    required this.date,
    required this.destination,
    required this.discount,
    required this.id,
    required this.source,
    required this.updatedAt,
    required this.vehicleIdId,
    required this.occupiedSeats,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
        basePrice: json['basePrice'],
        category: json['category'],
        createdAt: json['createdAt'],
        date: json['date'],
        destination: json['destination'],
        discount: json['discount'],
        id: json['id'],
        source: json['source'],
        updatedAt: json['updatedAt'],
        vehicleIdId: json['vehicleIdId'],
        occupiedSeats: json['occupiedSeats']);
  }

  factory TicketModel.fromJson1(Map<String, dynamic> json) {
    return TicketModel(
      basePrice: json['basePrice'],
      category: json['category'],
      date: json['date'],
      source: json['source'],
      destination: json['destination'],
      createdAt: '',
      discount: '',
      id: '',
      updatedAt: '',
      vehicleIdId: '',
      occupiedSeats: [],
    );
  }
}
