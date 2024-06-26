// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Quarto {
  late int id;
  late int number;
  late int occupancy;
  late QuartoStatus status;

  Quarto({required this.id, required this.number, required this.occupancy, required this.status});

  Quarto.noId({required int number, required int occupancy, required QuartoStatus status}) {
    this.number = number;
    this.occupancy = occupancy;
    this.status = status;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'number': number, 'occupancy': occupancy, 'status': status.name};
  }

  factory Quarto.fromMap(Map<String, dynamic> map) {
    return Quarto(
        id: map['id'] as int,
        number: map['number'] as int,
        occupancy: map['occupancy'] as int,
        status: QuartoStatus.values.byName(map['status']));
  }

  String toJson() => json.encode(toMap());

  factory Quarto.fromJson(String source) => Quarto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quarto(id: $id, number: $number, occupancy: $occupancy, status: $status)';
  }
}

enum QuartoStatus { OCUPADO, USADO, LIVRE }

Map<QuartoStatus, Color> StatusColors = {
  QuartoStatus.LIVRE: Colors.green,
  QuartoStatus.OCUPADO: Colors.red,
  QuartoStatus.USADO: Colors.yellow
};
