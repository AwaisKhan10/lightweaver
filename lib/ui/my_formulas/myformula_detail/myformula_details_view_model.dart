// ignore_for_file: avoid_print

import 'package:lightweaver/core/enums/view_state_model.dart';
import 'package:lightweaver/core/model/formula_model.dart';
import 'package:lightweaver/core/others/base_view_model.dart';
import 'package:lightweaver/core/services/auth_services.dart';
import 'package:lightweaver/core/services/db_services.dart';
import 'package:lightweaver/locator.dart';

class MyFormulaDetailsViewModel extends BaseViewModel {
  bool? sent;

  final _dbServices = locator<DatabaseServices>();
  final _auth = locator<AuthServices>();
  MyFormulaDetailsViewModel() {
    getAllFormulas();
  }

  List<FormulaModel> _allFormulas = []; // All data (backup)
  List<FormulaModel> _formulas = []; // Filtered data

  List<FormulaModel> get formulas => _formulas;

  Future<void> getAllFormulas() async {
    setState(ViewState.busy);
    try {
      _allFormulas = await _dbServices.getAllFormulas("${_auth.appUser.id}");
      _formulas = _allFormulas; // Initially show all
      notifyListeners();
    } catch (e) {
      print('Error getting formulas: $e');
    } finally {
      setState(ViewState.idle);
    }
  }

  void searchFormulasByName(String query) {
    if (query.isEmpty) {
      _formulas = _allFormulas;
    } else {
      _formulas =
          _allFormulas
              .where(
                (formula) =>
                    formula.formulaName!.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    formula.clientName!.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
    notifyListeners();
  }
}
