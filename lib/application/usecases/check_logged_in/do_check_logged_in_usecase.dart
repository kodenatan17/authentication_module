import 'package:authentication_module/domain/repositories/auth_repository.dart';
import 'package:core_module/domain/entities/base_result_entities.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DoCheckLoggedInUseCase {
  final AuthRepository _authRepository;  

  DoCheckLoggedInUseCase(this._authRepository);

  @override
  Future<ResultEntity<bool>> call() async {
    return await _authRepository.isLoggedIn(); 
  }
}