import 'package:ez_either/ez_either.dart';
import 'package:surpraise_infra/surpraise_infra.dart'
    hide DatabaseDatasource, SaveQuery, GetQuery;

import '../../../../core/core.dart';
import '../../auth.dart';

class DefaultAuthService implements AuthService {
  const DefaultAuthService({
    required SupabaseCloudClient supabaseClient,
    required HttpClient httpClient,
    required DatabaseDatasource databaseDatasource,
  })  : _supabase = supabaseClient,
        _datasource = databaseDatasource,
        _client = httpClient;

  final SupabaseCloudClient _supabase;
  final HttpClient _client;
  final DatabaseDatasource _datasource;

  @override
  AsyncAction<String> signinStepOne(SignInFormDataDto input) async {
    try {
      final result = await _supabase.signIn(
        email: input.username,
        password: input.password,
      );
      return Right(result);
    } on Exception catch (_) {
      return Left(
        InvalidCredentialsException(),
      );
    }
  }

  @override
  AsyncAction<GetUserOutput> signinStepTwo(String input) async {
    try {
      final result = await _client.get("/user/$input");
      return Right(
        GetUserOutput(
          tag: result.data["tag"],
          name: result.data["name"],
          email: result.data["email"],
          id: result.data["id"],
        ),
      );
    } on Exception catch (e) {
      return Left(e);
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
