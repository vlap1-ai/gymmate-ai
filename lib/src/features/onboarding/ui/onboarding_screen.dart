import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/onboarding_models.dart';
import '../onboarding_state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _gymController = TextEditingController();

  int _currentStep = 0;
  Gender? _selectedGender;
  FitnessGoal? _selectedGoal;
  DateTime? _selectedBirthday;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(onboardingDataProvider);
    _firstNameController.text = saved.firstName;
    _lastNameController.text = saved.lastName;
    _heightController.text = saved.heightCm?.toStringAsFixed(0) ?? '';
    _weightController.text = saved.weightKg?.toStringAsFixed(0) ?? '';
    _gymController.text = saved.gymName;
    _selectedGender = saved.gender;
    _selectedGoal = saved.fitnessGoal;
    _selectedBirthday = saved.birthday;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _gymController.dispose();
    super.dispose();
  }

  String get _stepLabel {
    return ['Welcome', 'Profile', 'Body', 'Goal', 'Permissions'][_currentStep];
  }

  void _persistStep() {
    final notifier = ref.read(onboardingDataProvider.notifier);
    switch (_currentStep) {
      case 0:
        notifier.updateNames(_firstNameController.text, _lastNameController.text);
        break;
      case 1:
        if (_selectedBirthday != null) {
          notifier.updateBirthday(_selectedBirthday!);
        }
        if (_selectedGender != null) {
          notifier.updateGender(_selectedGender!);
        }
        break;
      case 2:
        final height = double.tryParse(_heightController.text);
        final weight = double.tryParse(_weightController.text);
        if (height != null && weight != null) {
          notifier.updatePhysical(height, weight);
        }
        break;
      case 3:
        if (_selectedGoal != null) {
          notifier.updateFitnessGoal(_selectedGoal!);
        }
        break;
      case 4:
        notifier.updateGymName(_gymController.text);
        break;
    }
  }

  void _nextStep() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _persistStep();
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      return;
    }
    context.go('/permissions');
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (date != null) {
      setState(() => _selectedBirthday = date);
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: 'First name',
              hintText: 'Enter your first name',
              controller: _firstNameController,
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter your first name' : null,
            ),
            const SizedBox(height: 20),
            InputField(
              label: 'Last name',
              hintText: 'Enter your last name',
              controller: _lastNameController,
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter your last name' : null,
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Birthday', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickBirthday,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  _selectedBirthday == null ? 'Select your birthday' : DateFormat.yMMMMd().format(_selectedBirthday!),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Gender', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: Gender.values.map((gender) {
                final label = gender == Gender.male
                    ? 'Male'
                    : gender == Gender.female
                        ? 'Female'
                        : 'Other';
                final selected = _selectedGender == gender;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedGender = gender),
                );
              }).toList(),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: 'Height (cm)',
              hintText: '180',
              controller: _heightController,
              keyboardType: TextInputType.number,
              validator: (value) {
                final number = double.tryParse(value ?? '');
                if (number == null || number <= 0) return 'Enter a valid height';
                return null;
              },
            ),
            const SizedBox(height: 20),
            InputField(
              label: 'Weight (kg)',
              hintText: '75',
              controller: _weightController,
              keyboardType: TextInputType.number,
              validator: (value) {
                final number = double.tryParse(value ?? '');
                if (number == null || number <= 0) return 'Enter a valid weight';
                return null;
              },
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: FitnessGoal.values.map((goal) {
            final label = goal == FitnessGoal.gainMuscle
                ? 'Gain Muscle'
                : goal == FitnessGoal.loseFat
                    ? 'Lose Fat'
                    : 'Maintain';
            final selected = _selectedGoal == goal;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                tileColor: selected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
                title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
                trailing: selected ? const Icon(Icons.check_circle) : null,
                onTap: () => setState(() => _selectedGoal = goal),
              ),
            );
          }).toList(),
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: 'Regular gym',
              hintText: 'Enter your gym name',
              controller: _gymController,
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Please add your gym' : null,
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next step', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const Text('GymMate AI will request location, notification, and Apple Health permissions once you continue.'),
                    const SizedBox(height: 12),
                    const Text('These permissions enable automatic gym detection, workout tracking, and tailored nutrition guidance.'),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressText = '${_currentStep + 1} / 5';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('GymMate AI', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('The AI Companion That Grows With You.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_stepLabel, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(progressText, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 14),
                  Expanded(
                    child: PrimaryButton(
                      label: _currentStep < 4 ? 'Next' : 'Finish Setup',
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
