import 'package:equatable/equatable.dart';

class AuthRequestOtpData extends Equatable {
  final String? token;

  const AuthRequestOtpData({this.token});

  @override
  List<Object?> get props => [token];
}
