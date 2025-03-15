// ignore_for_file: deprecated_member_use
import 'package:bookmywod_admin/sample.dart';
import 'package:bookmywod_admin/screens/components/create_catagory_component.dart';
import 'package:bookmywod_admin/screens/components/date_tile.dart';
import 'package:bookmywod_admin/screens/components/fitness_catagories_container.dart';
import 'package:bookmywod_admin/screens/components/side_navbar.dart';
import 'package:bookmywod_admin/screens/schedule/all_session_view.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/models/catagory_model.dart';
import 'package:bookmywod_admin/services/database/models/gym_model.dart';
import 'package:bookmywod_admin/services/database/models/trainer_model.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../shared/constants/Icons.dart';
import '../shared/constants/bg_gardient.dart';

class HomeScreen extends StatefulWidget {
  final AuthUser authUser;
  final SupabaseDb supabaseDb;

  const HomeScreen(
      {super.key, required this.authUser, required this.supabaseDb});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  CatagoryModel? catagory;
  @override
  void initState() {
    super.initState();
    selectedIndex = DateTime.now().weekday - 1;
  }

  List<DateTime> getWeekDates() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDates();
    return FutureBuilder<TrainerModel?>(
        future: widget.supabaseDb.getTrainerByAuthId(widget.authUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: customWhite,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final trainerModel = snapshot.data;
          if (trainerModel == null) {
            return const Scaffold(
              body: Center(
                child: Text('User not found'),
              ),
            );
          }
          return Scaffold(
            drawer: SideNavbar(
              userModel: trainerModel,
              authUser: widget.authUser,
              supabaseDb: widget.supabaseDb,
            ),
            appBar: AppBar(
              backgroundColor: scaffoldBackgroundColor,
              titleSpacing: 0.0
              ,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${trainerModel.fullName} ✨',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<GymModel?>(
                    future: widget.supabaseDb.getGym(trainerModel.gymId),
                    builder: (context, gymSnapshot) {
                      if (gymSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      if (gymSnapshot.hasError) {
                        return const Text('Error loading gym details');
                      }

                      final gym = gymSnapshot.data;
                      return Text(capitalizeFirst(gym?.name ?? '',),

                        style: TextStyle(
                          color: customBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),

                ],
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListScreen(
                                  currentUserId: widget.authUser.id,
                                )));
                    // GoRouter.of(context).push('/search');
                  },
                  icon:SvgPicture.asset(AppIcons.mail), // Icon
                ),
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).push('/notifications');
                  },
                  icon:  SvgPicture.asset(AppIcons.notification),
                )
              ],
            ),
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(

                  gradient: AppGradients.primaryGradient
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: StreamBuilder(
                    stream: widget.supabaseDb
                        .getAllCatagoriesByCreator(trainerModel.trainerId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          children: [
                            Text('No Catagory yet created'),
                            const SizedBox(height: 16),
                            CreateCatagoryComponent(
                              widget: widget,
                              trainerModel: trainerModel,
                              gymId: catagory?.gymId ?? '',
                              creatorId: catagory?.createdAt ?? '',
                              catId: catagory?.catagoryId ?? '',
                            ),
                          ],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LoadingScreen();
                      } else if (snapshot.data == null) {
                        return const Text('No Catagory yet created');
                      } else {
                        final data = snapshot.data ?? [];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),

                                    ), gradient: AppGradients.primaryGradient),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 7,
                                            itemBuilder: (context, index) {
                                              DateTime date = weekDates[index];
                                              return DateTile(
                                                day: DateFormat('d').format(date),
                                                weekday: DateFormat('EEE')
                                                    .format(date),
                                                isSelected:
                                                    index == selectedIndex,
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = index;
                                                  });
                                                },
                                              );
                                            }),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        DateFormat('EEEE, d MMMM yyyy')
                                            .format(weekDates[selectedIndex]),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 15,)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Todays Session',
                                      style: TextStyle(
                                        color: customWhite,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllSessionView(
                                                  supabaseDb: widget.supabaseDb,
                                                  catagoryName: catagory!.name,
                                                  creatorId: catagory!.uuidOfCreator,
                                                  catagoryId: catagory!.catagoryId ?? '',
                                                  gymId: trainerModel.gymId,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'See All',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    catagory = data[index];
                                    return FitnessCategoriesContainer(
                                      name: catagory!.name,
                                      categories:
                                          catagory!.features?.join(', ') ?? '',
                                      onTap: () {
                                        GoRouter.of(context).push(
                                          '/session-view',
                                          extra: {
                                            'supabaseDb': widget.supabaseDb,
                                            'catagoryName': catagory!.name,
                                            'catagoryId': catagory!.catagoryId,
                                            'creatorId': catagory!.uuidOfCreator,
                                            'gymId': trainerModel.gymId,
                                          },
                                        );
                                      },
                                      // Image URL is not fetch from backend. Check this for temp i use the manually image from assets
                                      image: catagory!.image ??
                                          'assets/events/heavylifting.png',
                                      sessionCount: 5,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 20,
                                  ),
                                  itemCount: data.length,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: double.infinity,
                                    height: 130,

                                    // alignment:
                                    //     Alignment.centerLeft, // Centers content
                                    decoration: BoxDecoration(
                                      color: customDarkBlue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Centers text horizontally
                                        children: [
                                          Text(
                                            'Add New Categories',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: customWhite,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          OutlinedButton(

                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors
                                                      .blue), // Use customBlue if defined
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 10),
                                            ),
                                            onPressed: () => {
                                              GoRouter.of(context).push(
                                                '/create-catagory',
                                                extra: {
                                                  'supabaseDb': widget.supabaseDb,
                                                  'trainerModel': trainerModel,
                                                  'catagoryId':
                                                      catagory!.catagoryId,
                                                  'creatorId':
                                                      catagory!.uuidOfCreator,
                                                  'gymId': catagory!.gymId,
                                                },
                                              )
                                            },
                                            child: const Text(
                                              'Add New Categories',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     GoRouter.of(context).push(
                                          //       '/create-catagory',
                                          //       extra: {
                                          //         'supabaseDb': widget.supabaseDb,
                                          //         'trainerModel': trainerModel,
                                          //         'catagoryId': catagory!.catagoryId,
                                          //         'creatorId':
                                          //             catagory!.uuidOfCreator,
                                          //         'gymId': catagory!.gymId,
                                          //       },
                                          //     );
                                          //   },
                                          //   child: Container(
                                          //     padding: const EdgeInsets.all(10),
                                          //     decoration: BoxDecoration(
                                          //       color: Color(0xFF21374D),
                                          //       border: Border.all(
                                          //           color: customBlue,
                                          //           width: 2), // Outline border
                                          //       borderRadius: BorderRadius.circular(
                                          //           30), // Rounded corners
                                          //     ),
                                          //     child: Icon(
                                          //       Icons.add, // Add icon
                                          //       color: customWhite,
                                          //       size:
                                          //           24, // Adjust icon size as needed
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ),
          );
        });
  }
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
