import 'package:lightweaver/core/enums/view_state_model.dart';
import 'package:lightweaver/core/model/remedies_categories.dart';
import 'package:lightweaver/core/model/remedy_details.dart';
import 'package:lightweaver/core/others/base_view_model.dart';
import 'package:lightweaver/core/services/db_services.dart';
import 'package:lightweaver/locator.dart';

class RemedyDetailsViewModel extends BaseViewModel {
  int _selectedQuickLinkIndex = 0;
  int selectedTabIndex = 0;

  final databaseServices = locator<DatabaseServices>();

  int get selectedQuickLinkIndex => _selectedQuickLinkIndex;

  List<RemedyDetailsModel> filteredRemedies = [];
  List<RemedyCategoryModel> remedyList = [];

  // Constructor or init method
  RemedyDetailsViewModel() {
    // _initializeRemedyList();
    getRemedies();
    // searchRemediesFromFirebase("${remedyList[selectedTabIndex].categoryName}");
  }

  getRemedies() async {
    setState(ViewState.busy);

    // Step 1: Get categories from DB
    List<RemedyCategoryModel> rawCategories =
        await databaseServices.getRemedyCategories();

    // Step 2: Merge remedies by categoryName
    Map<String, List<RemedyDetailsModel>> categoryMap = {};

    for (var category in rawCategories) {
      final name = category.categoryName?.trim() ?? 'Unknown';

      if (!categoryMap.containsKey(name)) {
        categoryMap[name] = [];
      }

      categoryMap[name]!.addAll(category.remedies ?? []);
    }

    // Step 3: Convert map to RemedyCategoryModel list
    remedyList =
        categoryMap.entries.map((entry) {
          return RemedyCategoryModel(
            id: entry.key, // you can keep unique or dummy id
            categoryName: entry.key,
            remedies: entry.value,
          );
        }).toList();

    // Step 4: Create 'All' tab by combining all remedies
    List<RemedyDetailsModel> allRemedies =
        (remedyList.expand(
          (category) => category.remedies ?? [],
        )).cast<RemedyDetailsModel>().toList();

    remedyList.insert(
      0,
      RemedyCategoryModel(id: '0', categoryName: 'All', remedies: allRemedies),
    );

    // Step 5: Set filtered list for display
    selectedTabIndex = 0;
    filteredRemedies = allRemedies;

    setState(ViewState.idle);
    notifyListeners();
  }

  Future<void> searchRemediesFromFirebase(String name) async {
    setState(ViewState.busy);

    if (name.isEmpty) {
      // If name is empty, show all remedies
      filteredRemedies = remedyList[0].remedies ?? [];
    } else {
      // Call DB service function
      filteredRemedies = await databaseServices.getRemediesByNameLocally(name);
    }

    setState(ViewState.idle);
    notifyListeners();
  }

  Future<void> searchRemediesByName(String name) async {
    setState(ViewState.busy);

    final query = name.toLowerCase().trim();
    final allRemedies = remedyList[0].remedies ?? [];

    if (query.isEmpty) {
      filteredRemedies = allRemedies;
    } else {
      filteredRemedies =
          allRemedies.where((remedy) {
            final remedyName = remedy.name?.toLowerCase() ?? '';
            final keywords = remedy.keywords?.map((e) => e.toLowerCase()) ?? [];

            return remedyName.contains(query) ||
                keywords.any((keyword) => keyword.contains(query));
          }).toList();
    }

    setState(ViewState.idle);
    notifyListeners();
  }

  // Aur selectTabFunction me aise hi rahne do:
  void selectTabFunction(int index) {
    selectedTabIndex = index;
    filteredRemedies = remedyList[index].remedies ?? [];
    notifyListeners();
  }

  // void _initializeRemedyList() {
  //   // Static list of actual categories
  //   List<RemedyCategoryModel> categories = [
  //     RemedyCategoryModel(
  //       id: '1',
  //       categoryName: 'Categories',
  //       remedies: [
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Categories Rock Rose',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //           symptoms: ['awais', 'Soft'],
  //           related: ['fds', 'dfsd', 'dssd'],
  //           properties: ['sdfc', 'efds', 'dfsd'],
  //           chakras: ['hvbhj', 'uhhub'],
  //           description:
  //               'jhygtfdresdtfguhjkjhiguyfdtrstfghjk;hgufdytrsdfghjhguyfdtfhjnhgfytdhjnk;lhgufyyghjkl;jhlgfyghjknlmjhgufyhjknlm;jhgyfvhbjn vyuigfytgubnjiuvg vgbuhvguw',
  //         ),
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Categories Mimulus',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Categories Cherry Plum',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //       ],
  //     ),
  //     RemedyCategoryModel(
  //       id: '2',
  //       categoryName: 'Vibration',
  //       remedies: [
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Vibration Rose',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Vibration Mimulus',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Vibration Cherry Plum',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //       ],
  //     ),
  //     RemedyCategoryModel(
  //       id: '3',
  //       categoryName: 'Usage',
  //       remedies: [
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Usage',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Usage Mimulus',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //         RemedyDetailsModel(
  //           image: AppAssets().profile,
  //           name: 'Usage Cherry Plum',
  //           forCondition: ['Panic', 'Shock'],
  //           keywords: ['fear', 'OverWhelm'],
  //         ),
  //       ],
  //     ),
  //   ];

  //   // Combine all remedies for "All" tab
  //   List<RemedyDetailsModel> allRemedies =
  //       categories
  //           .expand((category) => category.remedies ?? [])
  //           .cast<RemedyDetailsModel>()
  //           .toList();

  //   // Add "All" tab at the beginning
  //   remedyList = [
  //     RemedyCategoryModel(id: '0', categoryName: 'All', remedies: allRemedies),
  //     ...categories,
  //   ];

  //   // Set default to all remedies
  //   filteredRemedies = allRemedies;
  //   notifyListeners();
  // }

  void selectQuickLink(int index) {
    _selectedQuickLinkIndex = index;
    notifyListeners();
  }

  ///
  ///      remedy details card
  ///
  int selectedCardIndex = 0;

  void selectCard(int index) {
    selectedCardIndex = index;
    notifyListeners();
  }
}
