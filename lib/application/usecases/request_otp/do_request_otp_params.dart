import 'package:equatable/equatable.dart';

class DoRequestOtpParams extends Equatable {
  final String phone;
  final String password;

  const DoRequestOtpParams({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}
