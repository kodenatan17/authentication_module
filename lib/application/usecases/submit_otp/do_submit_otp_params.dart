import 'package:equatable/equatable.dart';

class DoSubmitOtpParams extends Equatable {
  final String phone;
  final String otp;

  const DoSubmitOtpParams({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}
