import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_event.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_state.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  final AuthService _authService;
  SplashViewModel({required AuthService authService})
    : _authService = authService,
      super(SplashState()) {
    on<AppStart>(_onAppStart);
  }

  Future<void> _onAppStart(AppStart event, Emitter<SplashState> emit) async {
    final token = await _authService.getToken();
    if (token != null) {
      emit(AuthenticatedUser());
    } else {
      emit(UnAuthenticatedUser());
    }
  }
}
