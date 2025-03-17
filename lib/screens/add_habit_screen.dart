import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/habit_model.dart';
import '../services/assistant_helper.dart';
import '../widgets/icon_picker_dialog.dart';
import 'package:uuid/uuid.dart';

class AddHabitScreen extends StatefulWidget {
  final AssistantType assistantType;
  final Habit? habit;

  const AddHabitScreen({
    super.key,
    required this.assistantType,
    this.habit,
  });

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late HabitType _type;
  late HabitFrequency _frequency;
  late TimeOfDay _reminderTime;
  IconData _selectedIcon = Icons.star;

  @override
  void initState() {
    super.initState();
    _title = widget.habit?.title ?? '';
    _type = widget.habit?.type ?? HabitType.good;
    _frequency = widget.habit?.frequency ?? HabitFrequency.daily;
    _reminderTime = TimeOfDay.fromDateTime(
      widget.habit?.reminderTime ?? DateTime.now(),
    );
  }

  Color _getBackgroundColor(AssistantType type) {
    switch (type) {
      case AssistantType.panda:
        return const Color(0xFF4CAF50).withOpacity(0.15);
      case AssistantType.cat:
        return const Color(0xFF9C27B0).withOpacity(0.15);
      case AssistantType.fox:
        return const Color(0xFFFF5722).withOpacity(0.15);
    }
  }

  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AssistantHelper.primaryColors[widget.assistantType]!;
    final backgroundColor = _getBackgroundColor(widget.assistantType);
    final textColor = _getTextColor(backgroundColor);

    return Theme(
      data: theme.copyWith(
        textTheme: GoogleFonts.rubikTextTheme(theme.textTheme),
        colorScheme: theme.colorScheme.copyWith(
          primary: primaryColor,
          background: backgroundColor,
          onBackground: textColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.habit == null ? 'Add Habit' : 'Edit Habit',
            style: GoogleFonts.rubik(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  AssistantHelper.emojis[widget.assistantType]!,
                  style: const TextStyle(fontSize: 64),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  GestureDetector(
                    onTap: _showIconPicker,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _selectedIcon,
                        size: 32,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _title,
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Habit Name',
                        labelStyle: GoogleFonts.rubik(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Please enter a habit name',
                        hintStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a habit name';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SegmentedButton<HabitType>(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.selected)
                        ? primaryColor
                        : Colors.white,
                  ),
                ),
                segments: [
                  ButtonSegment(
                    value: HabitType.good,
                    label: Text(
                      'Good Habit',
                      style: GoogleFonts.rubik(
                        color: _type == HabitType.good ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: Icon(
                      Icons.thumb_up,
                      color: _type == HabitType.good ? Colors.white : Colors.black87,
                    ),
                  ),
                  ButtonSegment(
                    value: HabitType.bad,
                    label: Text(
                      'Bad Habit',
                      style: GoogleFonts.rubik(
                        color: _type == HabitType.bad ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: Icon(
                      Icons.thumb_down,
                      color: _type == HabitType.bad ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (Set<HabitType> selected) {
                  setState(() => _type = selected.first);
                },
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<HabitFrequency>(
                value: _frequency,
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  labelStyle: GoogleFonts.rubik(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: HabitFrequency.daily,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          'Daily',
                          style: GoogleFonts.rubik(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: HabitFrequency.weekly,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_view_week, color: primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          'Weekly',
                          style: GoogleFonts.rubik(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: HabitFrequency.monthly,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month, color: primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          'Monthly',
                          style: GoogleFonts.rubik(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _frequency = value!);
                },
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: primaryColor,
                            surface: Colors.white,
                            onSurface: Colors.black87,
                          ),
                          textTheme: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).copyWith(
                            bodyLarge: GoogleFonts.rubik(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            bodyMedium: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            labelSmall: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          timePickerTheme: TimePickerThemeData(
                            backgroundColor: Colors.white,
                            hourMinuteShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            dayPeriodShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            dayPeriodColor: Colors.white,
                            dialHandColor: primaryColor,
                            dialBackgroundColor: primaryColor.withOpacity(0.1),
                            hourMinuteColor: Colors.white,
                            dialTextColor: Colors.black87,
                          ),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            alwaysUse24HourFormat: false,
                          ),
                          child: child!,
                        ),
                      );
                    },
                  );
                  if (time != null) {
                    setState(() => _reminderTime = time);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: primaryColor),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reminder Time',
                            style: GoogleFonts.rubik(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(Icons.save),
                label: Text(
                  'Save Habit',
                  style: GoogleFonts.rubik(fontSize: 16),
                ),
                onPressed: _saveHabit,
              ),
              if (widget.habit != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                  icon: const Icon(Icons.delete),
                  label: Text(
                    'Delete Habit',
                    style: GoogleFonts.rubik(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showIconPicker() async {
    final IconData? icon = await showDialog<IconData>(
      context: context,
      builder: (context) => IconPickerDialog(
        assistantType: widget.assistantType,
      ),
    );

    if (icon != null) {
      setState(() => _selectedIcon = icon);
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final now = DateTime.now();
      final reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      final habit = Habit(
        id: widget.habit?.id ?? const Uuid().v4(),
        title: _title,
        type: _type,
        frequency: _frequency,
        reminderTime: reminderDateTime,
        createdAt: widget.habit?.createdAt ?? now,
        completionLog: widget.habit?.completionLog ?? {},
        icon: _selectedIcon,
      );

      Navigator.pop(context, habit);
    }
  }
} 