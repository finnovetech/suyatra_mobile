import 'package:equatable/equatable.dart';

class MainCategoryEntity extends Equatable {
  final int id;
  final String title;
  final String value;

  const MainCategoryEntity({
    required this.id,
    required this.title,
    required this.value,
  });
  @override
  List<Object?> get props => [
    id,
    title,
    value,
  ];
}
