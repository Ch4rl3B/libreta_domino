import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

abstract class ViewModelPageBuilder<T extends ChangeNotifier>
    extends StackedView<T> {
  final T? overrideViewModel;

  const ViewModelPageBuilder({super.key, this.overrideViewModel});

  @override
  bool get createNewViewModelOnInsert => overrideViewModel == null;

  @override
  T viewModelBuilder(BuildContext context);
}
