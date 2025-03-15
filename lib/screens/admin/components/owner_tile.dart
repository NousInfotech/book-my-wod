import 'package:bookmywod_admin/screens/admin/add_admin_view.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';

class OwnerTile extends StatelessWidget {
  final AddAdminView widget;
  final TrainerModel userModel;
  final AuthUser authUser;
  const OwnerTile({
    super.key,
    required this.widget, required this.userModel, required this.authUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: widget.userModel.avatarUrl != null
            ? NetworkImage(widget.userModel.avatarUrl!)
            : const AssetImage('assets/home/default_profile.png')
                as ImageProvider,
      ),
      title: Text(widget.userModel.fullName,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
      subtitle: Text(widget.authUser.email,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: customTextColor),),
      trailing: Container(
        padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 15),
        decoration: BoxDecoration(

          borderRadius:   BorderRadius.circular(20),
          border: Border.all(color: customBlue, width: 1),
        ),
        child: const Text(
          'Owner',
          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
