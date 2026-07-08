import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import 'chip_option.dart';
import 'labeled_text_field.dart';
import 'time_picker_field.dart';

/// The 8-question form shared by onboarding and the profile-edit screen.
/// Access the current values via the [ProfileFormFieldsState] returned by
/// [key], and [ProfileFormFieldsState.isValid] / [ProfileFormFieldsState.result].
class ProfileFormFields extends StatefulWidget {
  final UserProfile initial;
  final ValueChanged<bool>? onValidityChanged;

  const ProfileFormFields({super.key, required this.initial, this.onValidityChanged});

  @override
  State<ProfileFormFields> createState() => ProfileFormFieldsState();
}

class ProfileFormFieldsState extends State<ProfileFormFields> {
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _countryController;

  late Gender _gender;
  late Goal _goal;
  late ExerciseLevel _exerciseLevel;
  late TimeOfDay _wakeTime;
  late TimeOfDay _sleepTime;
  late DietType _dietType;
  late MealsPerDayPreference _mealsPerDay;
  late Budget _budget;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _ageController = TextEditingController(text: p.age.toString());
    _heightController = TextEditingController(text: p.heightCm.toString());
    _weightController = TextEditingController(text: p.weightKg.toString());
    _countryController = TextEditingController(text: p.country);
    _gender = p.gender;
    _goal = p.goal;
    _exerciseLevel = p.exerciseLevel;
    _wakeTime = p.wakeTime;
    _sleepTime = p.sleepTime;
    _dietType = p.dietType;
    _mealsPerDay = p.mealsPerDayPreference;
    _budget = p.budget;

    for (final c in [_ageController, _heightController, _weightController, _countryController]) {
      c.addListener(() {
        setState(() {});
        widget.onValidityChanged?.call(isValid);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onValidityChanged?.call(isValid));
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  bool get isValid =>
      (int.tryParse(_ageController.text) ?? 0) > 0 &&
      (int.tryParse(_heightController.text) ?? 0) > 0 &&
      (int.tryParse(_weightController.text) ?? 0) > 0 &&
      _countryController.text.trim().isNotEmpty;

  UserProfile get result => UserProfile(
        age: int.parse(_ageController.text),
        heightCm: int.parse(_heightController.text),
        weightKg: int.parse(_weightController.text),
        gender: _gender,
        goal: _goal,
        exerciseLevel: _exerciseLevel,
        wakeTime: _wakeTime,
        sleepTime: _sleepTime,
        country: _countryController.text.trim(),
        dietType: _dietType,
        mealsPerDayPreference: _mealsPerDay,
        budget: _budget,
        dislikedFoods: widget.initial.dislikedFoods,
        allergicFoods: widget.initial.allergicFoods,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledTextField(
                label: 'Age',
                controller: _ageController,
                keyboardType: TextInputType.number,
                suffixText: 'yrs',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabeledTextField(
                label: 'Height',
                controller: _heightController,
                keyboardType: TextInputType.number,
                suffixText: 'cm',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabeledTextField(
                label: 'Weight',
                controller: _weightController,
                keyboardType: TextInputType.number,
                suffixText: 'kg',
              ),
            ),
          ],
        ),
        _ChipSection<Gender>(
          label: 'Gender',
          options: Gender.values,
          selected: _gender,
          labelOf: (g) => g.label,
          onSelect: (g) => setState(() => _gender = g),
        ),
        _ChipSection<Goal>(
          label: "What's your goal?",
          options: Goal.values,
          selected: _goal,
          labelOf: (g) => g.label,
          emojiOf: (g) => g.emoji,
          onSelect: (g) => setState(() => _goal = g),
        ),
        _ChipSection<ExerciseLevel>(
          label: 'Exercise',
          options: ExerciseLevel.values,
          selected: _exerciseLevel,
          labelOf: (e) => e.label,
          emojiOf: (e) => e.emoji,
          onSelect: (e) => setState(() => _exerciseLevel = e),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TimePickerField(
                label: 'Wake time',
                value: _wakeTime,
                onChanged: (t) => setState(() => _wakeTime = t),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TimePickerField(
                label: 'Sleep time',
                value: _sleepTime,
                onChanged: (t) => setState(() => _sleepTime = t),
              ),
            ),
          ],
        ),
        LabeledTextField(
          label: 'Country',
          controller: _countryController,
          hintText: 'e.g. United States',
        ),
        _ChipSection<DietType>(
          label: 'Diet type',
          options: DietType.values,
          selected: _dietType,
          labelOf: (d) => d.label,
          onSelect: (d) => setState(() => _dietType = d),
        ),
        _ChipSection<MealsPerDayPreference>(
          label: 'Meals per day',
          options: MealsPerDayPreference.values,
          selected: _mealsPerDay,
          labelOf: (m) => m.label,
          onSelect: (m) => setState(() => _mealsPerDay = m),
        ),
        _ChipSection<Budget>(
          label: 'Budget',
          options: Budget.values,
          selected: _budget,
          labelOf: (b) => b.label,
          emojiOf: (b) => b.emoji,
          onSelect: (b) => setState(() => _budget = b),
        ),
      ],
    );
  }
}

class _ChipSection<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final String Function(T)? emojiOf;
  final ValueChanged<T> onSelect;

  const _ChipSection({
    required this.label,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelect,
    this.emojiOf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipGroupLabel(label),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map((o) => ChipOption(
                    label: labelOf(o),
                    emoji: emojiOf?.call(o),
                    selected: o == selected,
                    onTap: () => onSelect(o),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
