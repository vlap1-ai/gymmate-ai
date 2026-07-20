import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_state.dart';
import 'models/user_profile.dart';
import 'user_profile_state.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _goalWeightController = TextEditingController();
  DateTime? _dateOfBirth;
  String _gender = 'Prefer not to say';
  String _activityLevel = 'Moderate';
  String _fitnessGoal = 'Maintain weight';
  String _preferredUnits = 'Metric';
  bool _submitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  void _populateFields(UserProfile profile) {
    _fullNameController.text = profile.fullName;
    _dateOfBirth = profile.dateOfBirth;
    _gender = profile.gender;
    _heightController.text = profile.height.toString();
    _weightController.text = profile.weight.toString();
    _goalWeightController.text = profile.goalWeight.toString();
    _preferredUnits = profile.preferredUnits;
    _activityLevel = profile.activityLevel;
    _fitnessGoal = profile.fitnessGoal;
  }

  Future<void> _saveProfile(String uid, String email, UserProfile? existingProfile) async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose your date of birth.')));
      }
      return;
    }

    setState(() => _submitting = true);
    try {
      final profile = UserProfile(
        uid: uid,
        email: email,
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        gender: _gender,
        height: double.parse(_heightController.text.trim()),
        weight: double.parse(_weightController.text.trim()),
        goalWeight: double.parse(_goalWeightController.text.trim()),
        preferredUnits: _preferredUnits,
        activityLevel: _activityLevel,
        fitnessGoal: _fitnessGoal,
        createdAt: existingProfile?.createdAt ?? DateTime.now(),
      );

      await ref.read(userProfileActionProvider).saveProfile(profile);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to save profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _dateOfBirth ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13, now.month, now.day),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Auth error: $error'))),
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: const Center(child: Text('Please sign in to manage your profile.')),
          );
        }

        final profileAsync = ref.watch(userProfileStreamProvider(user.uid));
        return profileAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stack) => Scaffold(body: Center(child: Text('Profile load failed: $error'))),
          data: (profile) {
            if (!_initialized) {
              if (profile != null) {
                _populateFields(profile);
              }
              _initialized = true;
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          Text('Profile information', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: user.email,
                            decoration: const InputDecoration(labelText: 'Email'),
                            readOnly: true,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _fullNameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Full name'),
                            validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your full name' : null,
                          ),
                          const SizedBox(height: 12),
                          InputDecorator(
                            decoration: const InputDecoration(labelText: 'Date of birth'),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _dateOfBirth != null ? '${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}' : 'Select date',
                                  ),
                                ),
                                TextButton(onPressed: _pickDateOfBirth, child: const Text('Choose')),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _gender,
                            decoration: const InputDecoration(labelText: 'Gender'),
                            items: const [
                              DropdownMenuItem(value: 'Male', child: Text('Male')),
                              DropdownMenuItem(value: 'Female', child: Text('Female')),
                              DropdownMenuItem(value: 'Other', child: Text('Other')),
                              DropdownMenuItem(value: 'Prefer not to say', child: Text('Prefer not to say')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => _gender = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _heightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(labelText: 'Height (${_preferredUnits == 'Metric' ? 'cm' : 'in'})'),
                            validator: (value) {
                              final parsed = double.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Enter a valid height';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(labelText: 'Weight (${_preferredUnits == 'Metric' ? 'kg' : 'lb'})'),
                            validator: (value) {
                              final parsed = double.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Enter a valid weight';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _goalWeightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(labelText: 'Goal weight (${_preferredUnits == 'Metric' ? 'kg' : 'lb'})'),
                            validator: (value) {
                              final parsed = double.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Enter a valid goal weight';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _preferredUnits,
                            decoration: const InputDecoration(labelText: 'Preferred units'),
                            items: const [
                              DropdownMenuItem(value: 'Metric', child: Text('Metric')),
                              DropdownMenuItem(value: 'Imperial', child: Text('Imperial')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => _preferredUnits = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _activityLevel,
                            decoration: const InputDecoration(labelText: 'Activity level'),
                            items: const [
                              DropdownMenuItem(value: 'Sedentary', child: Text('Sedentary')),
                              DropdownMenuItem(value: 'Light', child: Text('Light')),
                              DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
                              DropdownMenuItem(value: 'Active', child: Text('Active')),
                              DropdownMenuItem(value: 'Very active', child: Text('Very active')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => _activityLevel = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _fitnessGoal,
                            decoration: const InputDecoration(labelText: 'Fitness goal'),
                            items: const [
                              DropdownMenuItem(value: 'Maintain weight', child: Text('Maintain weight')),
                              DropdownMenuItem(value: 'Lose weight', child: Text('Lose weight')),
                              DropdownMenuItem(value: 'Gain muscle', child: Text('Gain muscle')),
                              DropdownMenuItem(value: 'Improve endurance', child: Text('Improve endurance')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => _fitnessGoal = value);
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _submitting ? null : () => _saveProfile(user.uid, user.email ?? '', profile),
                            child: _submitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save profile'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
