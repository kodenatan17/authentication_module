import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'authentication_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initAuthModule',
  preferRelativeImports: true,
  asExtension: true,
)
void configureInjection() => getIt.initAuthModule();

