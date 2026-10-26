import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/asset.dart';
import '../../providers/asset_provider.dart';
import '../../providers/worksite_provider.dart';
import '../../core/constants/app_colors.dart';

class AddEditAssetScreen extends StatefulWidget {
  final Asset? asset;

  const AddEditAssetScreen({super.key, this.asset});

  @override
  State<AddEditAssetScreen> createState() => _AddEditAssetScreenState();
}

class _AddEditAssetScreenState extends State<AddEditAssetScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _manufacturerController;
  late TextEditingController _modelController;
  late TextEditingController _operatorController;
  late TextEditingController _notesController;

  String _category = 'Excavators';
  String _operationalStatus = 'Operational';
  String _maintenanceStatus = 'Good';
  String? _selectedSiteId;

  DateTime _lastInspection = DateTime.now().subtract(const Duration(days: 7));
  DateTime _nextMaintenance = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.asset?.name ?? '');
    _codeController = TextEditingController(
      text: widget.asset?.assetCode ?? 'EQ-AST-${100 + DateTime.now().second}',
    );
    _manufacturerController = TextEditingController(
      text: widget.asset?.manufacturer ?? 'Caterpillar',
    );
    _modelController = TextEditingController(
      text: widget.asset?.model ?? '349FL',
    );
    _operatorController = TextEditingController(
      text: widget.asset?.assignedOperator ?? '',
    );
    _notesController = TextEditingController(text: widget.asset?.notes ?? '');

    if (widget.asset != null) {
      _category = widget.asset!.category;
      _operationalStatus = widget.asset!.operationalStatus;
      _maintenanceStatus = widget.asset!.maintenanceStatus;
      _selectedSiteId = widget.asset!.siteId;
      _lastInspection = widget.asset!.lastInspectionDate;
      _nextMaintenance = widget.asset!.nextMaintenanceDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _manufacturerController.dispose();
    _modelController.dispose();
    _operatorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetProvider = Provider.of<AssetProvider>(context, listen: false);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);

    if (_selectedSiteId == null && worksiteProvider.worksites.isNotEmpty) {
      _selectedSiteId = worksiteProvider.worksites.first.id;
    }

    final isEditing = widget.asset != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Asset Record' : 'Register New Asset'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Asset Name *',
                  prefixIcon: Icon(Icons.precision_manufacturing),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter asset name'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Asset Code / ID *',
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter asset code'
                    : null,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Excavators',
                    child: Text('Excavators'),
                  ),
                  DropdownMenuItem(value: 'Cranes', child: Text('Cranes')),
                  DropdownMenuItem(value: 'Loaders', child: Text('Loaders')),
                  DropdownMenuItem(
                    value: 'Haul Trucks',
                    child: Text('Haul Trucks'),
                  ),
                  DropdownMenuItem(
                    value: 'Drilling Rigs',
                    child: Text('Drilling Rigs'),
                  ),
                  DropdownMenuItem(
                    value: 'Generators',
                    child: Text('Generators'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _manufacturerController,
                      decoration: const InputDecoration(
                        labelText: 'Manufacturer *',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter manufacturer'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model *',
                        prefixIcon: Icon(Icons.hardware),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter model'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _selectedSiteId,
                decoration: const InputDecoration(
                  labelText: 'Assigned Worksite *',
                  prefixIcon: Icon(Icons.location_city),
                ),
                items: worksiteProvider.worksites
                    .map(
                      (ws) =>
                          DropdownMenuItem(value: ws.id, child: Text(ws.name)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSiteId = val);
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _operatorController,
                decoration: const InputDecoration(
                  labelText: 'Assigned Operator (Optional)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _operationalStatus,
                decoration: const InputDecoration(
                  labelText: 'Operational Status',
                  prefixIcon: Icon(Icons.build_circle),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Operational',
                    child: Text('Operational'),
                  ),
                  DropdownMenuItem(
                    value: 'Maintenance Required',
                    child: Text('Maintenance Required'),
                  ),
                  DropdownMenuItem(
                    value: 'Out of Service',
                    child: Text('Out of Service'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _operationalStatus = val);
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final siteName = worksiteProvider.worksites
                        .firstWhere(
                          (ws) => ws.id == _selectedSiteId,
                          orElse: () => worksiteProvider.worksites.first,
                        )
                        .name;

                    final site = worksiteProvider.worksites.firstWhere(
                      (ws) => ws.id == _selectedSiteId,
                      orElse: () => worksiteProvider.worksites.first,
                    );

                    if (isEditing) {
                      final updated = widget.asset!.copyWith(
                        name: _nameController.text.trim(),
                        assetCode: _codeController.text.trim(),
                        category: _category,
                        manufacturer: _manufacturerController.text.trim(),
                        model: _modelController.text.trim(),
                        siteId: _selectedSiteId!,
                        worksiteName: siteName,
                        assignedOperator:
                            _operatorController.text.trim().isEmpty
                            ? null
                            : _operatorController.text.trim(),
                        operationalStatus: _operationalStatus,
                        notes: _notesController.text.trim(),
                      );
                      await assetProvider.updateAsset(updated);
                    } else {
                      final newAsset = Asset(
                        id: 'a_${DateTime.now().millisecondsSinceEpoch}',
                        assetCode: _codeController.text.trim(),
                        name: _nameController.text.trim(),
                        category: _category,
                        manufacturer: _manufacturerController.text.trim(),
                        model: _modelController.text.trim(),
                        siteId: _selectedSiteId!,
                        worksiteName: siteName,
                        assignedOperator:
                            _operatorController.text.trim().isEmpty
                            ? null
                            : _operatorController.text.trim(),
                        operationalStatus: _operationalStatus,
                        maintenanceStatus: _maintenanceStatus,
                        lastInspectionDate: _lastInspection,
                        nextMaintenanceDate: _nextMaintenance,
                        latitude: site.latitude,
                        longitude: site.longitude,
                        notes: _notesController.text.trim(),
                      );
                      await assetProvider.addAsset(newAsset);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarkGreen,
                ),
                child: Text(isEditing ? 'SAVE CHANGES' : 'REGISTER ASSET'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
