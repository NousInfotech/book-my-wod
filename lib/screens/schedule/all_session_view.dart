import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
// import 'package:bookmywod_admin/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllSessionView extends StatefulWidget {
  final SupabaseDb supabaseDb;
  final String catagoryName;
  final String creatorId;
  final String catagoryId;
  final String gymId;

  const AllSessionView({
    super.key,
    required this.supabaseDb,
    required this.catagoryName,
    required this.creatorId,
    required this.catagoryId,
    required this.gymId,
  });

  @override
  State<AllSessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<AllSessionView> {
  bool _hasTimedOut = false;

  @override
  void initState() {
    super.initState();
    // Add timeout to prevent endless loading
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && !_hasTimedOut) {
        setState(() {
          _hasTimedOut = true;
          print("SESSIONS LOADING: Timeout triggered");
        });
      }
    });
    
    // Print debug info on init
    print("SESSIONS INIT: Category ID: ${widget.catagoryId}");
  }

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
          // Enhanced debug information
          print("SESSIONS DEBUG: Connection state: ${snapshot.connectionState}");
          print("SESSIONS DEBUG: Has data: ${snapshot.hasData}");
          print("SESSIONS DEBUG: Has error: ${snapshot.hasError}");
          if (snapshot.hasError) print("SESSIONS DEBUG: Error: ${snapshot.error}");
          print("SESSIONS DEBUG: Data length: ${snapshot.data?.length ?? 'null'}"); 
          
          final data = snapshot.data ?? [];

          // Check for timeout
          if (_hasTimedOut && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Taking too long to load data',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasTimedOut = false;
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            print("Error in stream: ${snapshot.error}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text(
                    'Error loading sessions:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('Try again'),
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: data.isEmpty
                ? Center(
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? CircularProgressIndicator(
                            color: customBlue) // Show minimal loading indicator
                        : Text(
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
                                    ' ${match.group(1)}'); // Adds space before AM/PM
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
                                  session.coverImage ?? 'https://via.placeholder.com/70x70',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Image error: $error");
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.image_not_supported, color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white, // Explicit color for visibility
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/clock.svg',
                                          width: 16,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.blue, 
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '$startTime - $endTime',
                                          style: const TextStyle(
                                            fontSize: 14, 
                                            color: customWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: customBlue, width: 1.5),
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