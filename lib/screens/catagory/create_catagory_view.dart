// // // ignore_for_file: use_build_context_synchronously
// //
// // import 'dart:io';
// //
// // import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
// // import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
// // import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
// // import 'package:bookmywod_admin/shared/constants/colors.dart';
// // import 'package:bookmywod_admin/shared/custom_text_field.dart';
// // import 'package:bookmywod_admin/shared/show_snackbar.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // class CreateCatagoryView extends StatefulWidget {
// //   final SupabaseDb? supabaseDb;
// //   final TrainerModel? trainerModel;
// //   final String? creatorId;
// //   final String? catagoryId;
// //   final String? gymId;
// //
// //   const CreateCatagoryView({
// //     super.key,
// //     this.supabaseDb,
// //     this.trainerModel,
// //     required this.gymId,
// //     required this.creatorId,
// //     required this.catagoryId,
// //   });
// //
// //   @override
// //   State<CreateCatagoryView> createState() => _CreateCatagoryViewState();
// // }
// //
// // class _CreateCatagoryViewState extends State<CreateCatagoryView> {
// //   late final TextEditingController _catagoryNameController;
// //   late final TextEditingController _catagoryFeaturesController;
// //   final _formKey = GlobalKey<FormState>();
// //   File? _pickedImage;
// //   String? _imageUrl;
// //
// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //
// //     if (pickedFile == null) {
// //       if (mounted) {
// //         showSnackbar(context, 'No image selected', type: SnackbarType.error);
// //       }
// //       return;
// //     }
// //
// //     try {
// //       final imageBytes = await pickedFile.readAsBytes();
// //       final fileExt = pickedFile.path.split('.').last;
// //       final fileName =
// //           'category/${DateTime.now().millisecondsSinceEpoch}.$fileExt';
// //
// //       // Check file size
// //       final fileSize = imageBytes.length / (1024 * 1024);
// //       if (fileSize > 20) {
// //         if (mounted) {
// //           showSnackbar(context, 'Image size should be less than 20MB',
// //               type: SnackbarType.error);
// //         }
// //         return;
// //       }
// //
// //       await Supabase.instance.client.storage.from('category').uploadBinary(
// //             fileName,
// //             imageBytes,
// //             fileOptions: FileOptions(
// //               contentType: 'image/$fileExt',
// //               upsert: true,
// //             ),
// //           );
// //
// //       final imageUrl = Supabase.instance.client.storage
// //           .from('category')
// //           .getPublicUrl(fileName);
// //
// //       setState(() {
// //         _pickedImage = File(pickedFile.path);
// //         _imageUrl = imageUrl;
// //       });
// //
// //       if (mounted) {
// //         showSnackbar(
// //           context,
// //           'Image uploaded successfully!',
// //           type: SnackbarType.success,
// //         );
// //       }
// //     } on StorageException catch (e) {
// //       if (mounted) {
// //         showSnackbar(context, 'Failed to upload image: ${e.message}',
// //             type: SnackbarType.error);
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         showSnackbar(context, 'Unexpected error occurred: $e',
// //             type: SnackbarType.error);
// //       }
// //     } finally {}
// //   }
// //
// //   @override
// //   void initState() {
// //     print("check category Id ${widget.catagoryId}");
// //     print("Gym Idcheck ${widget.gymId}");
// //     print("creator Id Check ${widget.creatorId}");
// //     _catagoryNameController = TextEditingController();
// //     _catagoryFeaturesController = TextEditingController();
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _catagoryNameController.dispose();
// //     _catagoryFeaturesController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xff05121E),
// //       appBar: AppBar(
// //         title: const Text('Add Catagory'),
// //         backgroundColor: Color(0xff05121E),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Center(
// //           child: Card(
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //             color: customGrey,
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Form(
// //                 key: _formKey,
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   // Ensures all content aligns to the left
// //
// //                   children: [
// //                     _buildSectionTitle('Categories Name'),
// //                     const SizedBox(height: 10),
// //                     CustomTextField(
// //                       hintText: 'Catagory Name',
// //                       controller: _catagoryNameController,
// //                       keyboardType: TextInputType.text,
// //                       textInputAction: TextInputAction.next,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter category name';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     const SizedBox(height: 16),
// //                     CustomTextField(
// //                       hintText: 'Features',
// //                       controller: _catagoryFeaturesController,
// //                       keyboardType: TextInputType.text,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //                     const SizedBox(height: 10),
// //                     _buildSectionTitle('Session Cover'),
// //                     const SizedBox(height: 10),
// //                     _buildImagePicker(),
// //                     const SizedBox(height: 10),
// //                     const SizedBox(height: 10),
// //                     _buildActionButtons(),
// //                     const Divider(),
// //                     const SizedBox(height: 10),
// //                     _buildCreateSessionButton(),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildActionButtons() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         OutlinedButton(
// //           onPressed: () => Navigator.pop(context),
// //           style: OutlinedButton.styleFrom(
// //             foregroundColor: customBlue,
// //             // Text color
// //             side: const BorderSide(color: customBlue, width: 2),
// //             // Border color and width
// //             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //           ),
// //           child: const Text('Cancel'),
// //         ),
// //         ElevatedButton(
// //           onPressed: () async {
// //             if (_formKey.currentState!.validate()) {
// //               try {
// //                 var createdCatagory = CatagoryModel.newCatagory(
// //                   gymId: widget.trainerModel!.gymId,
// //                   uuidOfCreator: widget.trainerModel!.trainerId!,
// //                   image: _imageUrl,
// //                   name: _catagoryNameController.text,
// //                   features: _catagoryFeaturesController.text.split(','),
// //                 );
// //
// //                 await widget.supabaseDb?.createCatagory(createdCatagory);
// //
// //                 showSnackbar(
// //                   context,
// //                   'Catagory created successfully',
// //                   type: SnackbarType.success,
// //                 );
// //
// //                 Navigator.pop(context);
// //               } catch (e) {
// //                 showSnackbar(
// //                   context,
// //                   'Error creating category: ${e.toString()}',
// //                   type: SnackbarType.error,
// //                 );
// //               }
// //             }
// //           },
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.blue, // Set your desired color here
// //             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //           ),
// //           child: const Text(
// //             'Save',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildImagePicker() {
// //     return GestureDetector(
// //       onTap: _pickImage,
// //       child: Container(
// //         width: double.infinity,
// //         height: 150,
// //         decoration: BoxDecoration(
// //           color: customGrey,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(
// //             color: Color(0xffBAC0C6), // Border color
// //             width: 2, // Border width
// //           ),
// //         ),
// //         child: _pickedImage == null
// //             ? const Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Icon(CupertinoIcons.share, size: 30, color: Colors.white),
// //                     SizedBox(height: 8),
// //                     Text('Upload Image', style: TextStyle(color: Colors.white)),
// //                   ],
// //                 ),
// //               )
// //             : ClipRRect(
// //                 borderRadius: BorderRadius.circular(14),
// //                 // Prevents image from overflowing
// //                 child: Image.file(
// //                   _pickedImage!,
// //                   fit: BoxFit.cover,
// //                   width: double.infinity,
// //                   height: double.infinity,
// //                 ),
// //               ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSectionTitle(String title) {
// //     return Text(
// //       title,
// //       style: const TextStyle(
// //         fontSize: 16,
// //         fontWeight: FontWeight.bold,
// //         color: Colors.white,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCreateSessionButton() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         const Text('Create Session',
// //             style: TextStyle(fontSize: 18, color: Colors.white)),
// //         ElevatedButton(
// //           onPressed: () {
// //             print('Navigating with:');
// //             print('supabaseDb: ${widget.supabaseDb}');
// //             print('catagoryId: ${widget.catagoryId}');
// //             print('creatorId: ${widget.creatorId}');
// //             print('gymId: ${widget.gymId}');
// //             print('trainerModel: ${widget.trainerModel}');
// //             GoRouter.of(context).push('/create-session', extra: {
// //               'supabaseDb': widget.supabaseDb,
// //               'trainerModel': widget.trainerModel,
// //               'catagoryId': widget.catagoryId ?? "",
// //               'creatorId': widget.creatorId ?? "",
// //               'gymId': widget.gymId ?? "",
// //             });
// //
// //             // GoRouter.of(context).push('/create-catagory', extra: {
// //             //   'supabaseDb': widget.supabaseDb,
// //             //   'trainerModel': widget.trainerModel,
// //             //   'catagoryId': widget.catagoryId,
// //             //   'creatorId': widget.creatorId,
// //             //   'gymId': widget.gymId,
// //             // });
// //           },
// //           style: ElevatedButton.styleFrom(backgroundColor: customGrey),
// //           child: const Icon(Icons.add, color: Colors.white),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// // ignore_for_file: use_build_context_synchronously
//
// import 'dart:io';
//
// import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
// import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
// import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
// import 'package:bookmywod_admin/shared/constants/colors.dart';
// import 'package:bookmywod_admin/shared/custom_text_field.dart';
// import 'package:bookmywod_admin/shared/show_snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class CreateCatagoryView extends StatefulWidget {
//   final SupabaseDb? supabaseDb;
//   final TrainerModel? trainerModel;
//   final String? creatorId;
//   final String? catagoryId;
//   final String? gymId;
//
//   const CreateCatagoryView({
//     super.key,
//     this.supabaseDb,
//     this.trainerModel,
//     required this.gymId,
//     required this.creatorId,
//     required this.catagoryId,
//   });
//
//   @override
//   State<CreateCatagoryView> createState() => _CreateCatagoryViewState();
// }
//
// class _CreateCatagoryViewState extends State<CreateCatagoryView> {
//   late final TextEditingController _catagoryNameController;
//   late final TextEditingController _catagoryFeaturesController;
//   final _formKey = GlobalKey<FormState>();
//   File? _pickedImage;
//   String? _imageUrl;
//   bool _isUploading = false;
//
//   Future<bool> _pickImage() async {
//     // Set uploading state
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80, // Compress image for faster upload
//       );
//
//       if (pickedFile == null) {
//         showSnackbar(context, 'No image selected', type: SnackbarType.error);
//         return false;
//       }
//
//       // Read image as bytes
//       final imageBytes = await pickedFile.readAsBytes();
//
//       // Check file size (20MB limit)
//       final fileSize = imageBytes.length / (1024 * 1024);
//       if (fileSize > 20) {
//         showSnackbar(context, 'Image size should be less than 20MB',
//             type: SnackbarType.error);
//         return false;
//       }
//
//       // Create a unique file name
//       final fileExt = pickedFile.path.split('.').last.toLowerCase();
//       final fileName =
//           'category/${widget.gymId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
//
//       // Upload to Supabase storage
//       await Supabase.instance.client.storage.from('category').uploadBinary(
//             fileName,
//             imageBytes,
//             fileOptions: FileOptions(
//               contentType: 'image/$fileExt',
//               upsert: true,
//             ),
//           );
//
//       // Get the public URL
//       final imageUrl = Supabase.instance.client.storage
//           .from('category')
//           .getPublicUrl(fileName);
//
//       // Update state with new image
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//         _imageUrl = imageUrl;
//       });
//
//       showSnackbar(
//         context,
//         'Image uploaded successfully!',
//         type: SnackbarType.success,
//       );
//
//       return true;
//     } on StorageException catch (e) {
//       showSnackbar(context, 'Failed to upload image: ${e.message}',
//           type: SnackbarType.error);
//       return false;
//     } catch (e) {
//       showSnackbar(context, 'Unexpected error occurred: $e',
//           type: SnackbarType.error);
//       return false;
//     } finally {
//       // Reset uploading state
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     _catagoryNameController = TextEditingController();
//     _catagoryFeaturesController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _catagoryNameController.dispose();
//     _catagoryFeaturesController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff05121E),
//       appBar: AppBar(
//         title: const Text('Create New Category'),
//         backgroundColor: const Color(0xff05121E),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.blue, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             color: customGrey,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildSectionTitle('Category Name'),
//                     const SizedBox(height: 10),
//                     CustomTextField(
//                       hintText: 'Enter category name',
//                       controller: _catagoryNameController,
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter category name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     _buildSectionTitle('Features'),
//                     const SizedBox(height: 10),
//                     CustomTextField(
//                       hintText: 'Enter features (comma separated)',
//                       controller: _catagoryFeaturesController,
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                     ),
//                     const SizedBox(height: 20),
//                     _buildSectionTitle('Category Cover'),
//                     const SizedBox(height: 10),
//                     _buildImagePicker(),
//                     const SizedBox(height: 24),
//                     _buildActionButtons(),
//                     const Divider(color: Colors.grey, height: 40),
//                     _buildCreateSessionButton(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: ElevatedButton(
//             onPressed: _isUploading
//                 ? null
//                 : () async {
//                     if (_formKey.currentState!.validate()) {
//                       setState(() {
//                         _isUploading = true;
//                       });
//
//                       try {
//                         if (_imageUrl == null) {
//                           showSnackbar(
//                             context,
//                             'Please upload an image for the category',
//                             type: SnackbarType.error,
//                           );
//                           setState(() {
//                             _isUploading = false;
//                           });
//                           return;
//                         }
//
//                         var createdCatagory = CatagoryModel.newCatagory(
//                           gymId:
//                               widget.trainerModel?.gymId ?? widget.gymId ?? '',
//                           uuidOfCreator: widget.trainerModel?.trainerId ??
//                               widget.creatorId ??
//                               '',
//                           image: _imageUrl,
//                           name: _catagoryNameController.text,
//                           features: _catagoryFeaturesController.text.isEmpty
//                               ? []
//                               : _catagoryFeaturesController.text.split(','),
//                         );
//
//                         await widget.supabaseDb
//                             ?.createCatagory(createdCatagory);
//
//                         showSnackbar(
//                           context,
//                           'Category created successfully',
//                           type: SnackbarType.success,
//                         );
//
//                         Navigator.pop(context);
//                       } catch (e) {
//                         showSnackbar(
//                           context,
//                           'Error creating category: ${e.toString()}',
//                           type: SnackbarType.error,
//                         );
//                         setState(() {
//                           _isUploading = false;
//                         });
//                       }
//                     }
//                   },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               elevation: 2,
//             ),
//             child: _isUploading
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2.0,
//                     ),
//                   )
//                 : const Text(
//                     'Save Category',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImagePicker() {
//     return GestureDetector(
//       onTap: _isUploading ? null : _pickImage,
//       child: Container(
//         width: double.infinity,
//         height: 180,
//         decoration: BoxDecoration(
//           color: const Color(0xff1A2530),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.blue.withOpacity(0.5),
//             width: 1.5,
//           ),
//         ),
//         child: _isUploading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Colors.blue),
//               )
//             : _pickedImage == null
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.cloud_upload_outlined,
//                           size: 48,
//                           color: Colors.blue.withOpacity(0.8),
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Upload Image',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Tap to browse files',
//                           style: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(14),
//                         child: Image.file(
//                           _pickedImage!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       ),
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.6),
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             icon: const Icon(Icons.edit,
//                                 color: Colors.white, size: 18),
//                             onPressed: _pickImage,
//                             tooltip: 'Change image',
//                             padding: const EdgeInsets.all(8),
//                             constraints: const BoxConstraints(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     );
//   }
//
//   Widget _buildCreateSessionButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Create Session',
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: _isUploading
//               ? null
//               : () {
//                   // Validate category data before proceeding
//                   if (_formKey.currentState!.validate() && _imageUrl != null) {
//                     GoRouter.of(context).push('/create-session', extra: {
//                       'supabaseDb': widget.supabaseDb,
//                       'trainerModel': widget.trainerModel,
//                       'catagoryId': widget.catagoryId ?? "",
//                       'creatorId': widget.creatorId ?? "",
//                       'gymId': widget.gymId ?? "",
//                     });
//                   } else {
//                     showSnackbar(
//                       context,
//                       'Please complete category details first',
//                       type: SnackbarType.warning,
//                     );
//                   }
//                 },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           ),
//           icon: const Icon(Icons.add, color: Colors.white),
//           label:
//               const Text('New Session', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//
// class CreateCatagoryView extends StatefulWidget {
//   final SupabaseDb? supabaseDb;
//   final TrainerModel? trainerModel;
//   final String? creatorId;
//   final String? catagoryId;
//   final String? gymId;
//
//   const CreateCatagoryView({
//     super.key,
//     this.supabaseDb,
//     this.trainerModel,
//     required this.gymId,
//     required this.creatorId,
//     required this.catagoryId,
//   });
//
//   @override
//   State<CreateCatagoryView> createState() => _CreateCatagoryViewState();
// }
//
// class _CreateCatagoryViewState extends State<CreateCatagoryView> {
//   final TextEditingController _categoryNameController = TextEditingController();
//   final TextEditingController _categoryFeaturesController =
//       TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   File? _pickedImage;
//   String? _imageUrl;
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile == null) {
//       if (mounted) {
//         showSnackbar(context, 'No image selected', type: SnackbarType.error);
//       }
//       return;
//     }
//
//     try {
//       final imageBytes = await pickedFile.readAsBytes();
//       final fileName = 'category/${DateTime.now().millisecondsSinceEpoch}';
//
//       // Check file size
//       final fileSize = imageBytes.length / (1024 * 1024);
//       if (fileSize > 20) {
//         if (mounted) {
//           showSnackbar(context, 'Image size should be less than 20MB',
//               type: SnackbarType.error);
//         }
//         return;
//       }
//
//       await Supabase.instance.client.storage.from('category').uploadBinary(
//             fileName,
//             imageBytes,
//             fileOptions: FileOptions(
//               contentType: pickedFile.mimeType,
//               upsert: true,
//             ),
//           );
//
//       final imageUrl = Supabase.instance.client.storage
//           .from('category')
//           .getPublicUrl(fileName);
//
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//         _imageUrl = imageUrl;
//       });
//
//       print(imageUrl);
//
//       if (mounted) {
//         showSnackbar(
//           context,
//           'Image uploaded successfully!',
//           type: SnackbarType.success,
//         );
//       }
//     } on StorageException catch (e) {
//       if (mounted) {
//         showSnackbar(context, 'Failed to upload image: ${e.message}',
//             type: SnackbarType.error);
//       }
//     } catch (e) {
//       if (mounted) {
//         showSnackbar(context, 'Unexpected error occurred: $e',
//             type: SnackbarType.error);
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _categoryNameController.dispose();
//     _categoryFeaturesController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff05121E),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   width: double.infinity,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter, // Starts from the top
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent, // rgba(0, 0, 0, 0)
//                         Color(0xFF1A2D40), // #1A2D40
//                       ],
//                     ),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(40),
//                       bottomRight: Radius.circular(40),
//                     ),
//                   ),
//                   child: _pickedImage == null
//                       ? Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Row for back button and title
//                                 Row(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.arrow_back,
//                                           color: Colors.white),
//                                       onPressed: () => Navigator.pop(context),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                             8), // Space between icon and text
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: const [
//                                         Text(
//                                           'Create New Category',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                             height: 4), // Space between texts
//                                         Text(
//                                           'Manage Categories',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 // Cancel button aligned to the end
//                                 OutlinedButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   style: OutlinedButton.styleFrom(
//                                     side: const BorderSide(
//                                         color: Colors.blue), // Border color
//                                   ),
//                                   child: const Text(
//                                     'Cancel',
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Spacer(),
//                             GestureDetector(
//                               onTap: _pickImage,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.upload_file,
//                                     size: 30,
//                                     color: Colors.grey.shade400,
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     'Upload Image',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.network(
//                             _imageUrl!,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                           ),
//                         ),
//                   // : SizedBox(),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Category Name',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xff1A2530),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextFormField(
//                           controller: _categoryNameController,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: InputDecoration(
//                             hintText: 'Category Names',
//                             hintStyle: TextStyle(color: Colors.grey.shade500),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter category name';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       const Text(
//                         'Features',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xff1A2530),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextFormField(
//                           controller: _categoryFeaturesController,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: InputDecoration(
//                             hintText: 'Features',
//                             hintStyle: TextStyle(color: Colors.grey.shade500),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter features';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//
//                       const SizedBox(
//                           height: 200), // Spacer to push buttons to bottom
//
//                       // Save Button
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               try {
//                                 var createdCategory = CatagoryModel.newCatagory(
//                                   gymId: widget.trainerModel!.gymId,
//                                   uuidOfCreator:
//                                       widget.trainerModel!.trainerId!,
//                                   image: _imageUrl,
//                                   name: _categoryNameController.text,
//                                   features: _categoryFeaturesController
//                                           .text.isNotEmpty
//                                       ? _categoryFeaturesController.text
//                                           .split(',')
//                                       : [],
//                                 );
//
//                                 await widget.supabaseDb
//                                     ?.createCatagory(createdCategory);
//
//                                 if (mounted) {
//                                   showSnackbar(
//                                     context,
//                                     'Category created successfully',
//                                     type: SnackbarType.success,
//                                   );
//                                   Navigator.pop(context);
//                                 }
//                               } catch (e) {
//                                 showSnackbar(
//                                   context,
//                                   'Error creating category: ${e.toString()}',
//                                   type: SnackbarType.error,
//                                 );
//                               }
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                           ),
//                           child: const Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//                       const Divider(
//                         color: Color(0xFFb21374D),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Create Session Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Create Session',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                           FloatingActionButton.small(
//                             onPressed: () {
//                               GoRouter.of(context)
//                                   .push('/create-session', extra: {
//                                 'supabaseDb': widget.supabaseDb,
//                                 'trainerModel': widget.trainerModel,
//                                 'catagoryId': widget.catagoryId ?? "",
//                                 'creatorId': widget.creatorId ?? "",
//                                 'gymId': widget.gymId ?? "",
//                               });
//                             },
//                             shape:
//                                 const CircleBorder(), // Ensures circular shape
//                             backgroundColor: Color(0xFF21374D),
//                             child: const Icon(Icons.add, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Category Name Section
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// class CreateCatagoryView extends StatefulWidget {
//   final SupabaseDb? supabaseDb;
//   final TrainerModel? trainerModel;
//   final String? creatorId;
//   final String? catagoryId;
//   final String? gymId;
//   const CreateCatagoryView({
//     super.key,
//     this.supabaseDb,
//     this.trainerModel,
//     required this.gymId,
//     required this.creatorId,
//     required this.catagoryId,
//   });
//
//   @override
//   State<CreateCatagoryView> createState() => _CreateCatagoryViewState();
// }
//
// class _CreateCatagoryViewState extends State<CreateCatagoryView> {
//   final TextEditingController _categoryNameController = TextEditingController();
//   final TextEditingController _categoryFeaturesController =
//       TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   File? _pickedImage;
//   String? _imageUrl;
//   bool _isUploading = false;
//
//   @override
//   void dispose() {
//     _categoryNameController.dispose();
//     _categoryFeaturesController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile == null) {
//       if (mounted) {
//         showSnackbar(context, 'No image selected', type: SnackbarType.error);
//       }
//       return;
//     }
//
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       final imageBytes = await pickedFile.readAsBytes();
//       final fileName = 'category/${DateTime.now().millisecondsSinceEpoch}';
//
//       // Check file size
//       final fileSize = imageBytes.length / (1024 * 1024);
//       if (fileSize > 20) {
//         if (mounted) {
//           showSnackbar(context, 'Image size should be less than 20MB',
//               type: SnackbarType.error);
//         }
//         setState(() {
//           _isUploading = false;
//         });
//         return;
//       }
//
//       await Supabase.instance.client.storage.from('category').uploadBinary(
//             fileName,
//             imageBytes,
//             fileOptions: FileOptions(
//               contentType: pickedFile.mimeType,
//               upsert: true,
//             ),
//           );
//
//       final imageUrl = Supabase.instance.client.storage
//           .from('category')
//           .getPublicUrl(fileName);
//
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//         _imageUrl = imageUrl;
//         _isUploading = false;
//       });
//
//       if (mounted) {
//         showSnackbar(
//           context,
//           'Image uploaded successfully!',
//           type: SnackbarType.success,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//       });
//       if (mounted) {
//         if (e is StorageException) {
//           showSnackbar(context, 'Failed to upload image: ${e.message}',
//               type: SnackbarType.error);
//         } else {
//           showSnackbar(context, 'Unexpected error occurred: $e',
//               type: SnackbarType.error);
//         }
//       }
//     }
//   }
//
//   Widget _buildHeaderContent() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Back button and title
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(width: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Create New Category',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Manage Categories',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             // Cancel button
//             OutlinedButton(
//               onPressed: () => Navigator.pop(context),
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.blue),
//               ),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const Spacer(),
//         if (_imageUrl == null)
//           GestureDetector(
//             onTap: _pickImage,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.upload_file,
//                   size: 30,
//                   color: Colors.grey.shade400,
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'Upload Image',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildFormField({
//     required String label,
//     required TextEditingController controller,
//     required String hintText,
//     required String? Function(String?) validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xff1A2530),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: TextFormField(
//             controller: controller,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(color: Colors.grey.shade500),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//             validator: validator,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _saveCategory() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         var createdCategory = CatagoryModel.newCatagory(
//           gymId: widget.trainerModel!.gymId,
//           uuidOfCreator: widget.trainerModel!.trainerId!,
//           image: _imageUrl,
//           name: _categoryNameController.text,
//           features: _categoryFeaturesController.text.isNotEmpty
//               ? _categoryFeaturesController.text.split(',')
//               : [],
//         );
//
//         await widget.supabaseDb?.createCatagory(createdCategory);
//
//         if (mounted) {
//           showSnackbar(
//             context,
//             'Category created successfully',
//             type: SnackbarType.success,
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         showSnackbar(
//           context,
//           'Error creating category: ${e.toString()}',
//           type: SnackbarType.error,
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff05121E),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header container with gradient background
//                 Stack(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 150,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Color(0xFF1A2D40),
//                           ],
//                         ),
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(40),
//                           bottomRight: Radius.circular(40),
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(10),
//                       child: _buildHeaderContent(),
//                     ),
//                     if (_imageUrl != null)
//                       Positioned.fill(
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(40),
//                               bottomRight: Radius.circular(40),
//                             ),
//                             image: DecorationImage(
//                               image: NetworkImage(_imageUrl!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.black.withOpacity(0.3),
//                                   Colors.black.withOpacity(0.7),
//                                 ],
//                               ),
//                             ),
//                             child: _buildHeaderContent(),
//                           ),
//                         ),
//                       ),
//                     if (_isUploading)
//                       const Positioned.fill(
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // Form fields
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildFormField(
//                         label: 'Category Name',
//                         controller: _categoryNameController,
//                         hintText: 'Category Name',
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter category name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       _buildFormField(
//                         label: 'Features',
//                         controller: _categoryFeaturesController,
//                         hintText: 'Features (comma separated)',
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter features';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 200),
//
//                       // Save Button
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _saveCategory,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                             ),
//                             child: const Text(
//                               'Save',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//                       const Divider(color: Color(0xFFb21374D)),
//                       const SizedBox(height: 20),
//
//                       // Create Session Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Create Session',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                           FloatingActionButton.small(
//                             onPressed: () {
//                               GoRouter.of(context)
//                                   .push('/create-session', extra: {
//                                 'supabaseDb': widget.supabaseDb,
//                                 'trainerModel': widget.trainerModel,
//                                 'catagoryId': widget.catagoryId ?? "",
//                                 'creatorId': widget.creatorId ?? "",
//                                 'gymId': widget.gymId ?? "",
//                               });
//                             },
//                             shape: const CircleBorder(),
//                             backgroundColor: const Color(0xFF21374D),
//                             child: const Icon(Icons.add, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CreateCatagoryView extends StatefulWidget {
  final SupabaseDb? supabaseDb;
  final TrainerModel? trainerModel;
  final String? creatorId;
  final String? catagoryId;
  final String? gymId;

  const CreateCatagoryView({
    super.key,
    this.supabaseDb,
    this.trainerModel,
    required this.gymId,
    required this.creatorId,
    required this.catagoryId,
  });

  @override
  State<CreateCatagoryView> createState() => _CreateCatagoryViewState();
}

class _CreateCatagoryViewState extends State<CreateCatagoryView> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryFeaturesController =
      TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _imageUrl;
  bool _isUploading = false;
  //Add this to your _CreateCatagoryViewState class
  final List<String> _availableFeatures = [ 'HIIT', 'Strength Training', 'Cardio', 'Yoga', 'Crossfit', 'Weightlifting', 'Functional Fitness', 'Group Training', 'Personal Training', 'Mobility', 'Recovery', 'Boxing', 'Pilates', 'Endurance', 'Kettlebell', 'Bodyweight', ];
// final List<String> _availableFeatures = [
//   // Cardio & Conditioning
//   'HIIT',
//   'Cardio',
//   'Endurance',
//   'Circuit Training',
//   'Indoor Cycling',
//   'Running Club',
//   'Rowing',
  
//   // Strength & Power
//   'Strength Training',
//   'Powerlifting',
//   'Olympic Weightlifting',
//   'Functional Fitness',
//   'Kettlebell',
//   'Bodyweight',
//   'Resistance Training',
  
//   // Specialized Training
//   'Crossfit',
//   'Group Training',
//   'Personal Training',
//   'Sports Conditioning',
//   'Athletic Performance',
  
//   // Mind-Body
//   'Yoga',
//   'Pilates',
//   'Barre',
//   'Mobility',
//   'Recovery',
//   'Meditation',
//   'Stretching',
  
//   // Combat Sports
//   'Boxing',
//   'Kickboxing',
//   'MMA',
//   'Brazilian Jiu-Jitsu',
  
//   // Specialized Programs
//   'Nutrition Coaching',
//   'Weight Loss',
//   'Muscle Building',
//   'Senior Fitness',
//   'Pre/Post Natal',
// ];
final Set<String> _selectedFeatures = {};

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryFeaturesController.dispose();
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
      final fileName = 'category/${DateTime.now().millisecondsSinceEpoch}';

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

      await Supabase.instance.client.storage.from('category').uploadBinary(
            fileName,
            imageBytes,
            fileOptions: FileOptions(
              contentType: pickedFile.mimeType,
              upsert: true,
            ),
          );

      final imageUrl = Supabase.instance.client.storage
          .from('category')
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
                  Icons.calendar_month,
                  color: Colors.grey,
                ),
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
                    String formattedDate =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        var createdCategory = CatagoryModel.newCatagory(
          gymId: widget.trainerModel!.gymId,
          uuidOfCreator: widget.trainerModel!.trainerId!,
          image: _imageUrl,
          name: _categoryNameController.text,
          features: _selectedFeatures.toList(),
        );

        await widget.supabaseDb?.createCatagory(createdCategory);

        if (mounted) {
          showSnackbar(
            context,
            'Category created successfully',
            type: SnackbarType.success,
          );
          Navigator.pop(context);
        }
      } catch (e) {
        showSnackbar(
          context,
          'Error creating category: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff05121E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0), // Adjust for status bar
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff000000),
                        Color(0xff1A2D40)
                      ], // Gradient colors
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Side: Back Icon & Titles
                          Row(
                            children: [
                              // Back Arrow Icon
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(
                                  width: 8), // Space between icon and text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Create New Category',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Manage Categories',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors
                                          .white, // Slightly lighter color for subtext
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Right Side: Cancel Button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blue), // Outline color
                                borderRadius: BorderRadius.circular(30),
                                color: Colors
                                    .transparent, // Transparent background
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10), // Add spacing
                        child: _imageUrl == null
                            ? GestureDetector(
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
                                          Icon(
                                            Icons.cloud_upload_outlined,
                                            size: 30,
                                            color: Colors.grey.shade400,
                                          ),
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
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      _imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 150,
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
                      )
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        label: 'Category Name',
                        controller: _categoryNameController,
                        hintText: 'Category Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter category name';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   "Add Date & Time",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 18,
                      //       color: Colors.grey),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: _buildTimeField(
                      //         label: 'Starting Time',
                      //         controller:
                      //             startTimeController, // Create this controller
                      //         hintText: '8:00 AM',
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter starting time';
                      //           }
                      //           return null;
                      //         },
                      //         context: context,
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 20,
                      //     ),
                      //     Expanded(
                      //       child: _buildTimeField(
                      //         label: 'Ending Time',
                      //         controller:
                      //             endTimeController, // Create this controller
                      //         hintText: '10:00 AM',
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter ending time';
                      //           }
                      //           return null;
                      //         },
                      //         context: context,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: _buildDateField(
                      //         label: 'Start Date',
                      //         controller:
                      //             startDateController, // Create this controller
                      //         hintText: '12/03/2025',
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter start date';
                      //           }
                      //           return null;
                      //         },
                      //         context: context,
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 20,
                      //     ),
                      //     Expanded(
                      //       child: _buildDateField(
                      //         label: 'End Date',
                      //         controller:
                      //             endDateController, // Create this controller
                      //         hintText: '19/03/2025',
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter end date';
                      //           }
                      //           return null;
                      //         },
                      //         context: context,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Replace the _buildFormField for features with this implementation
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Features',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
    ),
    const SizedBox(height: 10),
    // Display selected features as chips with remove buttons
    if (_selectedFeatures.isNotEmpty)
      Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _selectedFeatures.map((feature) => Chip(
          backgroundColor: Colors.blue.withOpacity(0.2),
          label: Text(
            feature,
            style: const TextStyle(color: Colors.white),
          ),
          deleteIconColor: Colors.white,
          onDeleted: () {
            setState(() {
              _selectedFeatures.remove(feature);
            });
          },
        )).toList(),
      ),
    const SizedBox(height: 16),
    // Available features to select from
    Text(
      'Select Features:',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _availableFeatures.map((feature) => ActionChip(
        backgroundColor: _selectedFeatures.contains(feature) 
            ? Colors.blue 
            : const Color(0xff1A2530),
        label: Text(
          feature,
          style: TextStyle(
            color: _selectedFeatures.contains(feature) 
                ? Colors.white 
                : Colors.grey,
          ),
        ),
        onPressed: () {
          setState(() {
            if (_selectedFeatures.contains(feature)) {
              _selectedFeatures.remove(feature);
            } else {
              _selectedFeatures.add(feature);
            }
          });
        },
      )).toList(),
    ),
  ],
),

                      const SizedBox(height: 100),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveCategory,
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
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFb21374D)),
                      const SizedBox(height: 20),

                      // Create Session Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Create Session',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          FloatingActionButton.small(
                            onPressed: () {
                              GoRouter.of(context)
                                  .push('/create-session', extra: {
                                'supabaseDb': widget.supabaseDb,
                                'trainerModel': widget.trainerModel,
                                'catagoryId': widget.catagoryId ?? "",
                                'creatorId': widget.creatorId ?? "",
                                'gymId': widget.gymId ?? "",
                              });
                            },
                            shape: const CircleBorder(),
                            backgroundColor: const Color(0xFF21374D),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
