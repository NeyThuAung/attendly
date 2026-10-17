import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entity/dashboard_summary_entity.dart';
import '../repository/admin_repository.dart';

@lazySingleton
class GetDashboardSummaryUseCase implements UseCase<DataState<DashboardSummaryEntity>, void> {
  final AdminRepository _repository;
  const GetDashboardSummaryUseCase(this._repository);

  @override
  Future<DataState<DashboardSummaryEntity>> call(void param) {
    return _repository.getDashboardSummary();
  }
}
