import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart'
    hide DatabaseDatasource, SaveQuery, GetQuery, FilterOperator;

import '../../../../core/core.dart';
import '../../auth.dart';

class DefaultAuthService implements AuthService {
  const DefaultAuthService({
    required SupabaseCloudClient supabaseClient,
    required DatabaseDatasource databaseDatasource,
  })  : _supabase = supabaseClient,
        _datasource = databaseDatasource;

  final SupabaseCloudClient _supabase;
  final DatabaseDatasource _datasource;

  @override
  AsyncAction<GetUserOutput> signin(SignInFormDataDto input) async {
    try {
      final user = await _supabase.signIn(
        email: input.username,
        password: input.password,
      );
      final result = await _datasource.get(
        GetQuery(
          sourceName: "profile",
          operator: FilterOperator.equalsTo,
          value: user.id,
          fieldName: "user_id",
        ),
      );
      if (result.failure) {
        return Left(InvalidCredentialsException());
      }
      final data = result.multiData![0];
      return Right(
        GetUserOutput(
          tag: data["tag"],
          name: data["name"],
          email: data["email"],
          id: data["id"],
        ),
      );
    } on Exception catch (_) {
      return Left(
        InvalidCredentialsException(),
      );
    }
  }

  @override
  AsyncAction<void> logout() async {
    await _supabase.logout();
    return Right(null);
  }

  @override
  AsyncAction<CreateUserOutput> signup(SignupCredentialsDto input) async {
    try {
      final user = await _supabase.signUp(
        email: input.email,
        password: input.password,
      );

      final result = await _datasource.save(
        SaveQuery(
          sourceName: "profile",
          value: {
            "name": input.name,
            "email": input.email,
            "tag": input.tag,
            "user_id": user.id,
          },
        ),
      );
      if (result.failure) {
        return Left(Exception("Something went wrong signing you up"));
      }

      return Right(
        UserMapper.createUserOutputFromMap(
          result.multiData!.first,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
