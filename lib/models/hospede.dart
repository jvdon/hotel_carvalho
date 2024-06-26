// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Hospede {
  String nome;
  String cpf;

  Hospede({
    required this.nome,
    required this.cpf,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cpf': cpf,
    };
  }

  factory Hospede.fromMap(Map<String, dynamic> map) {
    return Hospede(
      nome: map['nome'] as String,
      cpf: map['cpf'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Hospede.fromJson(String source) {
    print(source);
    return Hospede.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  @override
  String toString() => 'Hospede(nome: $nome, cpf: $cpf)';
}
