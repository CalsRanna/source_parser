import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/database_page/database_view_model.dart';

@RoutePage()
class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  final viewModel = GetIt.instance.get<DatabaseViewModel>();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) {
        var body = switch (viewModel.level.value) {
          1 => _buildDatabaseView(),
          2 => _buildTableView(),
          3 => _buildRowView(),
          4 => _buildColumnView(),
          _ => const SizedBox(),
        };
        Widget? floatingActionButton;
        if (viewModel.level.value > 1) {
          floatingActionButton = FloatingActionButton.extended(
            label: Text('BACK'),
            onPressed: viewModel.back,
            icon: Icon(HugeIcons.strokeRoundedArrowUp03),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('Laconic Database Previewer')),
          body: body,
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  Widget _buildColumnView() {
    var paragraphs = viewModel.columnData.value.split('\n');
    return ListView.builder(
      itemBuilder: (_, index) => Text(paragraphs[index]),
      itemCount: paragraphs.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildDatabaseView() {
    return ListView.builder(
      itemBuilder: (_, index) => ListTile(
        onTap: () => viewModel.getTableData(index),
        title: Text(
          viewModel.tables.value[index],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      itemCount: viewModel.tables.value.length,
    );
  }

  Widget _buildRowView() {
    return ListView.builder(
      itemBuilder: (_, index) => ListTile(
        onTap: () => viewModel.getColumnData(index),
        title: Text(
          '${viewModel.rowData.value.keys.elementAt(index)}: ${viewModel.rowData.value.values.elementAt(index)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      itemCount: viewModel.rowData.value.length,
    );
  }

  Widget _buildTableView() {
    return ListView.builder(
      itemBuilder: (_, index) => ListTile(
        onTap: () => viewModel.getRowData(index),
        title: Text(
          viewModel.tableData.value[index].toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      itemCount: viewModel.tableData.value.length,
    );
  }
}
