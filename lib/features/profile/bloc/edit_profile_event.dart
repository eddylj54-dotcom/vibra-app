import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class EditProfileSubmitted extends EditProfileEvent {
  final String newName;
  // Por ahora, no manejamos la subida de fotos, solo el nombre.
  // final String? photoPath;

  const EditProfileSubmitted({required this.newName});

  @override
  List<Object?> get props => [newName];
}
