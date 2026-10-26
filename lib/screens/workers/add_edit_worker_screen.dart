import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/worker.dart';
import '../../providers/worker_provider.dart';
import '../../providers/worksite_provider.dart';
import '../../core/constants/app_colors.dart';

class AddEditWorkerScreen extends StatefulWidget {
  final Worker? worker;

  const AddEditWorkerScreen({super.key, this.worker});

  @override
  State<AddEditWorkerScreen> createState() => _AddEditWorkerScreenState();
}

class _AddEditWorkerScreenState extends State<AddEditWorkerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _departmentController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;

  String _role = 'Mining Engineer';
  String _shift = 'Morning (06:00 - 14:00)';
  String? _selectedSiteId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.worker?.fullName ?? '',
    );
    _codeController = TextEditingController(
      text: widget.worker?.workerCode ?? 'MG-${100 + DateTime.now().second}',
    );
    _departmentController = TextEditingController(
      text: widget.worker?.department ?? 'Operations',
    );
    _phoneController = TextEditingController(
      text: widget.worker?.contactNumber ?? '',
    );
    _emergencyNameController = TextEditingController(
      text: widget.worker?.emergencyContactName ?? '',
    );
    _emergencyPhoneController = TextEditingController(
      text: widget.worker?.emergencyContactPhone ?? '',
    );

    if (widget.worker != null) {
      _role = widget.worker!.role;
      _shift = widget.worker!.shift;
      _selectedSiteId = widget.worker!.siteId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerProvider>(context, listen: false);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);

    if (_selectedSiteId == null && worksiteProvider.worksites.isNotEmpty) {
      _selectedSiteId = worksiteProvider.worksites.first.id;
    }

    final isEditing = widget.worker != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Worker Profile' : 'Register New Worker'),
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
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter worker full name'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Worker ID Code *',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter worker code'
                    : null,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                  labelText: 'Job Role *',
                  prefixIcon: Icon(Icons.work),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Mining Engineer',
                    child: Text('Mining Engineer'),
                  ),
                  DropdownMenuItem(
                    value: 'Safety Technician',
                    child: Text('Safety Technician'),
                  ),
                  DropdownMenuItem(
                    value: 'Heavy Equipment Operator',
                    child: Text('Heavy Equipment Operator'),
                  ),
                  DropdownMenuItem(
                    value: 'Geologist',
                    child: Text('Geologist'),
                  ),
                  DropdownMenuItem(
                    value: 'Drill Master',
                    child: Text('Drill Master'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _role = val);
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department *',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter department'
                    : null,
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

              DropdownButtonFormField<String>(
                value: _shift,
                decoration: const InputDecoration(
                  labelText: 'Shift Schedule *',
                  prefixIcon: Icon(Icons.schedule),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Morning (06:00 - 14:00)',
                    child: Text('Morning (06:00 - 14:00)'),
                  ),
                  DropdownMenuItem(
                    value: 'Evening (14:00 - 22:00)',
                    child: Text('Evening (14:00 - 22:00)'),
                  ),
                  DropdownMenuItem(
                    value: 'Night (22:00 - 06:00)',
                    child: Text('Night (22:00 - 06:00)'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _shift = val);
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Worker Phone Contact *',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter contact phone'
                    : null,
              ),
              const SizedBox(height: 18),

              const Text(
                'Emergency Contact Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _emergencyNameController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact Name *',
                  prefixIcon: Icon(Icons.contact_emergency),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter emergency contact name'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact Phone *',
                  prefixIcon: Icon(Icons.phone_in_talk),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter emergency contact phone'
                    : null,
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

                    if (isEditing) {
                      final updated = widget.worker!.copyWith(
                        fullName: _nameController.text.trim(),
                        workerCode: _codeController.text.trim(),
                        role: _role,
                        department: _departmentController.text.trim(),
                        siteId: _selectedSiteId!,
                        worksiteName: siteName,
                        shift: _shift,
                        contactNumber: _phoneController.text.trim(),
                        emergencyContactName: _emergencyNameController.text
                            .trim(),
                        emergencyContactPhone: _emergencyPhoneController.text
                            .trim(),
                      );
                      await workerProvider.updateWorker(updated);
                    } else {
                      final newWorker = Worker(
                        id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                        workerCode: _codeController.text.trim(),
                        fullName: _nameController.text.trim(),
                        role: _role,
                        department: _departmentController.text.trim(),
                        siteId: _selectedSiteId!,
                        worksiteName: siteName,
                        contactNumber: _phoneController.text.trim(),
                        shift: _shift,
                        emergencyContactName: _emergencyNameController.text
                            .trim(),
                        emergencyContactPhone: _emergencyPhoneController.text
                            .trim(),
                        registrationDate: DateTime.now(),
                      );
                      await workerProvider.addWorker(newWorker);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarkGreen,
                ),
                child: Text(isEditing ? 'SAVE CHANGES' : 'REGISTER WORKER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
