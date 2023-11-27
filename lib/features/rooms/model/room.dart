class Room {
  final int? id;
  final String roomNumber;
  final String type;
  final double value;

  Room({
    this.id,
    required this.roomNumber,
    required this.type,
    required this.value
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      roomNumber: json['room_number'],
      type: json['room_type'],
      value: double.parse(json['room_value']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'room_number': roomNumber,
    'room_type': type,
    'room_value': value,
  };
}