import 'dart:io';
import 'package:bookmywod_admin/screens/sessions/session_sucess.dart'
    show SuccessScreen;
import 'package:bookmywod_admin/services/database/models/session_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/Icons.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

class CreateSessionView extends StatefulWidget {
  final SupabaseDb supabaseDb;
  final String gymId;
  final String catagoryId;
  final String creatorId;
  final SessionModel? sessionModel;

  const CreateSessionView({
    super.key,
    required this.supabaseDb,
    required this.gymId,
    required this.catagoryId,
    required this.creatorId,
    this.sessionModel,
  });

  @override
  State<CreateSessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<CreateSessionView> {
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> _selectedDays = [];
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  late final TextEditingController _catagoryNameController;
  late final TextEditingController _entryLimitController;
  late final TextEditingController _dateController;
  late final TextEditingController _catagoryDescriptionController;
  final List<DateTime> _selectedDates = [];
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _imageUrl;
  bool _sessionRepeat = false;
  List<TimeSlot> timeSlots = [TimeSlot()];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _catagoryNameController = TextEditingController();
    _entryLimitController = TextEditingController();
    _dateController = TextEditingController();
    _catagoryDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _catagoryNameController.dispose();
    _entryLimitController.dispose();
    _dateController.dispose();
    _catagoryDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      if (mounted) {
        showSnackbar(context, 'No image selected', type: SnackbarType.error);
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final imageBytes = await pickedFile.readAsBytes();
      final fileName = 'session/${DateTime.now().millisecondsSinceEpoch}';

      // Check file size
      final fileSize = imageBytes.length / (1024 * 1024);
      if (fileSize > 20) {
        if (mounted) {
          showSnackbar(context, 'Image size should be less than 20MB',
              type: SnackbarType.error);
        }
        setState(() {
          _isUploading = false;
        });
        return;
      }

      await Supabase.instance.client.storage.from('session').uploadBinary(
            fileName,
            imageBytes,
            fileOptions: FileOptions(
              contentType: pickedFile.mimeType,
              upsert: true,
            ),
          );

      final imageUrl = Supabase.instance.client.storage
          .from('session')
          .getPublicUrl(fileName);

      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrl = imageUrl;
        _isUploading = false;
      });

      if (mounted) {
        showSnackbar(
          context,
          'Image uploaded successfully!',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        if (e is StorageException) {
          showSnackbar(context, 'Failed to upload image: ${e.message}',
              type: SnackbarType.error);
        } else {
          showSnackbar(context, 'Unexpected error occurred: $e',
              type: SnackbarType.error);
        }
      }
    }
  }

  // Improved upload section UI
  Widget _buildUploadSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff1A2530),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: customDarkBlue, width: 1),
      ),
      child: _imageUrl == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _isUploading ? null : _pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isUploading)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      else
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.uplaod_image),
                            const SizedBox(width: 15),
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _imageUrl = null;
                        _pickedImage = null;
                      });
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff1A2530),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff1A2530),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            surface: Color(0xff1A2530),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xff1A2530),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    controller.text = pickedTime.format(context);
                  }
                },
              ),
            ),
            validator: validator,
            readOnly:
                true, // Makes the field read-only as time will be set via picker
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff1A2530),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: IconButton(
                icon: SvgPicture.asset(AppIcons.calendar),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            surface: Color(0xff1A2530),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xff1A2530),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    // Format the date as you prefer
                    String formattedDate = DateFormat("d MMM yyyy").format(pickedDate);
                    // Alternatively, use intl package for more formatting options:
                    // String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                    controller.text = formattedDate;
                  }
                },
              ),
            ),
            validator: validator,
            readOnly:
                true, // Makes the field read-only as date will be set via picker
          ),
        ),
      ],
    );
  }

 Widget _buildNumberField({
  required String label,
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?) validator,
}) {
  // Initialize with 1 if empty
  if (controller.text.isEmpty) {
    controller.text = '1';
  }
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        
        decoration: BoxDecoration(
          color: const Color(0xff1A2530),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicWidth(
          child: Row(
            children: [
              // Minus button
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                onPressed: () {
                  int currentValue = int.tryParse(controller.text) ?? 1;
                  if (currentValue > 1) {
                    controller.text = (currentValue - 1).toString();
                  }
                },
              ),
              // Text field
              Container(
                width: 70,
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  validator: validator,
                  keyboardType: TextInputType.number,
                ),
              ),
              // Plus button
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () {
                  int currentValue = int.tryParse(controller.text) ?? 0;
                  controller.text = (currentValue + 1).toString();
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  void _showNumberPicker(
      BuildContext context, TextEditingController controller) {
    // Get current value or default to 1
    int currentValue = int.tryParse(controller.text) ?? 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 330,
          decoration: const BoxDecoration(
            color: Color(0xff1A2530),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              // Handle indicator
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Entry Limit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xff21374D)),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xff21374D).withOpacity(0.5),
                        ),
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: currentValue - 1,
                          ),
                          backgroundColor: Colors.transparent,
                          itemExtent: 50,
                          diameterRatio: 1.5,
                          magnification: 1.2,
                          selectionOverlay: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 2,
                                ),
                                bottom: BorderSide(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          onSelectedItemChanged: (int index) {
                            controller.text = '${index + 1}';
                          },
                          children: List.generate(100, (index) {
                            return Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff05121E),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Create Session',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Session Name',
                    controller: _catagoryNameController,
                    hintText: 'Enter session name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter session name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff1A2530),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          dropdownColor: const Color(0xff1A2530),
                          style: const TextStyle(color: Colors.white),
                          hint: Text('Select category',
                              style: TextStyle(color: Colors.grey.shade500)),
                          items: [
                            'Crossfit',
                            'Yoga',
                            'HIIT',
                            'Pilates',
                            'Weightlifting',
                            'Boxing',
                            'Cardio',
                            'Strength'
                          ].map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            if (value != null) {
                              _catagoryNameController.text = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Date selection section
                  Text(
                    "Add Time",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ...timeSlots.asMap().entries.map((entry) {
                        final index = entry.key;
                        final slot = entry.value;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Slot ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (timeSlots.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        timeSlots.removeAt(index);
                                      });
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final TimeOfDay? startTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (startTime != null) {
                                        setState(() {
                                          timeSlots[index] =
                                              timeSlots[index].copyWith(
                                            startTime:
                                                '${startTime.hour}:${startTime.minute}',
                                          );
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1A2530),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(AppIcons.time),
                                          SizedBox(width: 10,),
                                          Text(
                                            slot.startTime.isNotEmpty
                                                ? slot.startTime
                                                : 'Start Time',
                                            style: TextStyle(
                                              color: slot.startTime.isNotEmpty
                                                  ? Colors.white
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      // final TimeOfDay? endTime =
                                      //     await showTimePicker(
                                      //   context: context,
                                      //   initialTime: TimeOfDay.now(),
                                      // );
                                      // if (endTime != null) {
                                      //   setState(() {
                                      //     timeSlots[index] =
                                      //         timeSlots[index].copyWith(
                                      //       endTime:
                                      //           '${endTime.hour}:${endTime.minute}',
                                      //     );
                                      //   });
                                      // }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1A2530),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(AppIcons.time),
                                          SizedBox(width: 10,),
                                          Text(
                                            slot.endTime.isNotEmpty
                                                ? slot.endTime
                                                : 'End Time',
                                            style: TextStyle(
                                              color: slot.endTime.isNotEmpty
                                                  ? Colors.white
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                      // Add new slot button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              timeSlots.add(TimeSlot());
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Add new Slot",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                   if (!_sessionRepeat) ...[
                    _buildDateField(
                      label: 'Select Date',
                      controller: startDateController,
                      hintText: '13 Mar 2025',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter start date';
                        }
                        return null;
                      },
                      context: context,
                    ),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Available Day',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff1A2530),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          dropdownColor: const Color(0xff1A2530),
                          style: const TextStyle(color: Colors.white),
                          hint: Text('Select day',
                              style: TextStyle(color: Colors.grey.shade500)),
                          items: _daysOfWeek.map((day) {
                            return DropdownMenuItem<String>(
                              value: day,
                              child: Text(day),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null &&
                                !_selectedDays.contains(value)) {
                              setState(() {
                                _selectedDays.add(value);
                              });
                            }
                          },
                        ),
                      ),
                      if (_selectedDays.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedDays.map((day) {
                            return Chip(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              label: Text(
                                day,
                                style: const TextStyle(color: Colors.white),
                              ),
                              deleteIcon: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                              onDeleted: () {
                                setState(() {
                                  _selectedDays.remove(day);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),

                 const SizedBox(height: 20),
                  // Repeat session toggle
                  // Row(
                  //   children: [
                  //     const Text(
                  //       'Repeat in Every Week',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     SizedBox(width: 10,),
                  //     Switch(
                  //       value: _sessionRepeat,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _sessionRepeat = value;
                  //         });
                  //       },
                  //       activeColor: Colors.blue,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Only show date field when _sessionRepeat is false
                  // Image upload section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Repeat in\nEvery Week',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Switch(
                              value: _sessionRepeat,
                              onChanged: (value) {
                                setState(() {
                                  _sessionRepeat = value;
                                });
                              },
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                        _buildNumberField(
                          label: 'Entry Limit',
                          controller: _entryLimitController,
                          hintText: 'Enter Limit',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter entry limit';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Session Cover',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildUploadSection(),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Save Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(
                                      color: customDarkBlue,
                                      width: 2), // Blue border
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: customBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    if (widget.gymId.isEmpty) {
                                      showSnackbar(context, "Invalid gym ID",
                                          type: SnackbarType.error);
                                      return;
                                    }
                                    if (widget.catagoryId.isEmpty) {
                                      showSnackbar(context, "Invalid category ID",
                                          type: SnackbarType.error);
                                      return;
                                    }
                                    if (widget.creatorId.isEmpty) {
                                      showSnackbar(context, "Invalid creator ID",
                                          type: SnackbarType.error);
                                      return;
                                    }
                                    if (widget.sessionModel == null) {
                                      final session = SessionModel(
                                        gymId: widget.gymId,
                                        name: _catagoryNameController.text,
                                        categoryId: widget.catagoryId,
                                        timeSlots: timeSlots
                                            .map((e) => e.toJson())
                                            .toList(),
                                        days: _selectedDates
                                            .map((d) => DateFormat('EEEE, M/d/y')
                                                .format(d))
                                            .toList(),
                                        sessionRepeat: _sessionRepeat,
                                        entryLimit: int.tryParse(
                                                _entryLimitController.text) ??
                                            0,
                                        sessionCreatedBy: widget.creatorId,
                                        coverImage: _imageUrl,
                                        description:
                                            _catagoryDescriptionController.text,
                                      );
                                      await widget.supabaseDb
                                          .createSession(session);
                                    } else {
                                      final session =
                                          widget.sessionModel!.copyWith(
                                        name: _catagoryNameController.text,
                                        categoryId: widget.catagoryId,
                                        timeSlots: timeSlots
                                            .map((e) => e.toJson())
                                            .toList(),
                                        days: _selectedDates
                                            .map((d) => DateFormat('EEEE, M/d/y')
                                                .format(d))
                                            .toList(),
                                        sessionRepeat: _sessionRepeat,
                                        entryLimit: int.tryParse(
                                            _entryLimitController.text),
                                        sessionCreatedBy: widget.creatorId,
                                        coverImage: _imageUrl,
                                        description:
                                            _catagoryDescriptionController.text,
                                      );
                                      await widget.supabaseDb
                                          .updateSession(session);
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SuccessScreen()));
                                  } catch (e) {
                                    showSnackbar(context, e.toString(),
                                        type: SnackbarType.error);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// TimeSlot model to manage time slot data
class TimeSlot {
  final String startTime;
  final String endTime;

  TimeSlot({
    this.startTime = '',
    this.endTime = '',
  });

  TimeSlot copyWith({
    String? startTime,
    String? endTime,
  }) {
    return TimeSlot(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, String> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
