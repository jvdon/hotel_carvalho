// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hotel_carvalho/models/hospede.dart';
import 'package:hotel_carvalho/models/quarto.dart';

class Reserva {
  late int id;

  List<Hospede> hospedes;
  List<Quarto> quartos;
  DateTime checkin;
  DateTime checkout;
  double valor;

  Reserva({
    required this.id,
    required this.hospedes,
    required this.quartos,
    required this.checkin,
    required this.checkout,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hospedes': hospedes.map((x) => x.toMap()).toList(),
      'quartos': quartos.map((x) => x.toMap()).toList(),
      'checkin': checkin.millisecondsSinceEpoch,
      'checkout': checkout.millisecondsSinceEpoch,
      'valor': valor,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    print(map['valor'].runtimeType);
    try {
      return Reserva(
        id: map['id'] as int,
        hospedes: List<Hospede>.from(((json.decode(map['hospedes']) as List).map<Hospede>((e) => Hospede.fromMap(e)))),
        quartos: List<Quarto>.from(((json.decode(map['quartos']) as List).map<Quarto>((e) => Quarto.fromMap(e)))),
        // quartos: List<Quarto>.from(
        //   (map['quartos'] as List<int>).map<Quarto>(
        //     (x) => Quarto.fromJson(x as String),
        //   ),
        // ),
        checkin: DateTime.fromMillisecondsSinceEpoch(map['checkin'] as int),
        checkout: DateTime.fromMillisecondsSinceEpoch(map['checkout'] as int),
        valor: double.parse(map['valor'].toString()),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  String toJson() => json.encode(toMap());

  factory Reserva.fromJson(String source) => Reserva.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reserva(id: $id, checkin: $checkin, checkout: $checkout, valor: $valor)';
  }
}
