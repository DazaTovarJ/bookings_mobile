import 'package:bookings_app/features/users/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<User?> {
  UserCubit(User? state) : super(state);

  void login(User user) => emit(user);

  void logout() => emit(null);
}