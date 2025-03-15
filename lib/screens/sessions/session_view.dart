import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//
// class SessionView extends StatefulWidget {
//   final SupabaseDb supabaseDb;
//   final String catagoryName;
//   final String creatorId;
//   final String catagoryId;
//   final String gymId;
//
//   const SessionView({
//     super.key,
//     required this.supabaseDb,
//     required this.catagoryName,
//     required this.creatorId,
//     required this.catagoryId,
//     required this.gymId,
//   });
//
//   @override
//   State<SessionView> createState() => _SessionViewState();
// }
//
// class _SessionViewState extends State<SessionView> {
//   int selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = DateTime.now().weekday - 1;
//   }
//
//   List<DateTime> getWeekDates() {
//     DateTime today = DateTime.now();
//     DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
//     return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<DateTime> weekDates = getWeekDates();
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: customDarkBlue,
//         title: Text(
//           widget.catagoryName,
//           style: GoogleFonts.barlow(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               GoRouter.of(context).push('/create-session', extra: {
//                 'supabaseDb': widget.supabaseDb,
//                 'catagoryId': widget.catagoryId,
//                 'creatorId': widget.creatorId,
//                 'gymId': widget.gymId,
//               });
//             },
//             icon: const Icon(Icons.add, color: Colors.white),
//           )
//         ],
//       ),
//       body: StreamBuilder(
//         stream: widget.supabaseDb.getAllSessionsByCatagory(widget.catagoryId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
//           } else if (snapshot.hasError) {
//             print("Error in stream: ${snapshot.error}");
//             return Center(
//               child: Text(
//                 'Error loading sessions: ${snapshot.error}',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No sessions available for this category',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }
//           final data = snapshot.data!;
//           return Column(
//             children: [
//               // Date Selector Section
//               Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: customDarkBlue,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(15),
//                     bottomRight: Radius.circular(15),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.1,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 7,
//                           itemBuilder: (context, index) {
//                             DateTime date = weekDates[index];
//                             return DateTile(
//                               day: DateFormat('d').format(date),
//                               weekday: DateFormat('EEE').format(date),
//                               isSelected: index == selectedIndex,
//                               onTap: () {
//                                 setState(() {
//                                   selectedIndex = index;
//                                 });
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         DateFormat('EEEE, d MMMM yyyy')
//                             .format(weekDates[selectedIndex]),
//                         style: GoogleFonts.barlow(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Session List Section
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: data.isEmpty
//                       ? const Center(
//                           child: Text(
//                             'No Sessions Available',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                         )
//                       : ListView.separated(
//                           itemCount: data.length,
//                           separatorBuilder: (context, index) =>
//                               const SizedBox(height: 16),
//                           itemBuilder: (context, index) {
//                             final session = data[index];
//                             String formatTime(String time) {
//                               return DateFormat.jm()
//                                   .format(DateFormat("HH:mm").parse(time))
//                                   .replaceAllMapped(
//                                       RegExp(r'([APM]+)$'),
//                                       (match) =>
//                                           ' ${match.group(1)}'); // Adds space before AM/PM
//                             }
//
//                             String startTime = session.timeSlots.isNotEmpty
//                                 ? formatTime(session.timeSlots[0]['startTime']!)
//                                 : 'N/A';
//
//                             String endTime = session.timeSlots.isNotEmpty
//                                 ? formatTime(session.timeSlots[0]['endTime']!)
//                                 : 'N/A';
//
//                             return GestureDetector(
//                               onTap: () {
//                                 GoRouter.of(context)
//                                     .push('/session-details', extra: {
//                                   'sessionModel': session,
//                                   'catagoryId': widget.catagoryId,
//                                   'creatorId': widget.creatorId,
//                                   'supabaseDb': widget.supabaseDb,
//                                 });
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: customDarkBlue,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.network(
//                                         session.coverImage ??
//                                             'https://placeholder.com/default-image.jpg',
//                                         width: 80,
//                                         height: 80,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) =>
//                                                 const Icon(Icons.error,
//                                                     color: Colors.white),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             session.name,
//                                             style: GoogleFonts.barlow(
//                                                 fontSize: 20,
//                                                 color: customWhite),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Row(
//                                             children: [
//                                               SvgPicture.asset(
//                                                 'assets/icons/clock.svg',
//                                                 width: 16,
//                                                 color: Colors.white,
//                                               ),
//                                               const SizedBox(width: 8),
//                                               Text(
//                                                 '$startTime - $endTime',
//                                                 style: const TextStyle(
//                                                     fontSize: 16,
//                                                     color: customWhite),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 8, vertical: 4),
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: customBlue, width: 1.5),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Text(
//                                         '${session.entryLimit.toString()}/15', // Convert entryLimit to String
//                                         style: GoogleFonts.barlow(
//                                           fontSize: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
class SessionView extends StatefulWidget {
  final SupabaseDb supabaseDb;
  final String catagoryName;
  final String creatorId;
  final String catagoryId;
  final String gymId;

  const SessionView({
    super.key,
    required this.supabaseDb,
    required this.catagoryName,
    required this.creatorId,
    required this.catagoryId,
    required this.gymId,
  });

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff05121E),
      appBar: AppBar(
        backgroundColor: const Color(0xff1A2530),
        title: Text(
          widget.catagoryName,
          style: GoogleFonts.barlow(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/create-session', extra: {
                'supabaseDb': widget.supabaseDb,
                'catagoryId': widget.catagoryId,
                'creatorId': widget.creatorId,
                'gymId': widget.gymId,
              });
            },
            icon: const Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: StreamBuilder(
        stream: widget.supabaseDb.getAllSessionsByCatagory(widget.catagoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            print("Error in stream: ${snapshot.error}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load sessions',
                    style: GoogleFonts.barlow(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Please check your connection and try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // This will trigger a rebuild and refresh the stream
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No sessions available for this category',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No Sessions Available',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.withOpacity(0.2),
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final session = data[index];
                      String formatTime(String time) {
                        return DateFormat.jm()
                            .format(DateFormat("HH:mm").parse(time))
                            .replaceAllMapped(
                                RegExp(r'([APM]+)$'),
                                (match) =>
                                    ' ${match.group(1)}');
                      }

                      String startTime = session.timeSlots.isNotEmpty
                          ? formatTime(session.timeSlots[0]['startTime']!)
                          : 'N/A';

                      String endTime = session.timeSlots.isNotEmpty
                          ? formatTime(session.timeSlots[0]['endTime']!)
                          : 'N/A';

                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push('/session-details', extra: {
                            'sessionModel': session,
                            'catagoryId': widget.catagoryId,
                            'creatorId': widget.creatorId,
                            'supabaseDb': widget.supabaseDb,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  session.coverImage ??
                                      'https://placeholder.com/default-image.jpg',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error,
                                          color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(session.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/clock.svg',
                                          width: 16,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '$startTime - $endTime',
                                          style: const TextStyle(
                                              fontSize: 14, color: customWhite),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: customBlue, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${session.entryLimit.toString()}/15',
                                  style: GoogleFonts.barlow(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}                           