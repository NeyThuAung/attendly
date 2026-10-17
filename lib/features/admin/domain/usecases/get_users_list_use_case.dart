import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../repository/admin_repository.dart';

class UsersListParam {
  final String? searchQuery;
  final int limit;

  const UsersListParam({this.searchQuery, this.limit = 20});
}

@lazySingleton
class GetUsersListUseCase
    implements UseCase<DataState<List<UserEntity>>, UsersListParam> {
  final AdminRepository _repository;

  const GetUsersListUseCase(this._repository);

  @override
  Future<DataState<List<UserEntity>>> call(UsersListParam param) {
    return _repository.getUsersList(
        searchQuery: param.searchQuery, limit: param.limit);
  }
}
