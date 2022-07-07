import 'package:get/get.dart';
import 'package:znote/repo/base_repo.dart';

class RepoGetXController extends GetxController {
  Map<String, dynamic> repos = {};

  void bindRepo(BaseRepo baseRepo) {
    String key = baseRepo.runtimeType.toString();
    if (repos[key] == null) {
      repos[key] = baseRepo;
    }
  }

  T getRepo<T>(Type repoType) {
    T repo = repos[repoType.toString()];
    return repo;
  }

  @override
  void onClose() {
    for (var element in repos.keys) {
      if (element is BaseRepo) (element as BaseRepo).onClose();
    }
    super.onClose();
  }
}
