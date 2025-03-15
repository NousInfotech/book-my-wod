import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembershipPlanScreen extends StatefulWidget {
  @override
  _MembershipPlanScreenState createState() => _MembershipPlanScreenState();
}

class _MembershipPlanScreenState extends State<MembershipPlanScreen> {
  int selectedIndex = 0; // Default selected tab
  final List<String> tabs = ["Trail", "Monthly", "Yearly"];
  
  bool isLoading = true;
  String errorMessage = '';
  
  // Data containers
  List<Map<String, dynamic>> trailPlans = [];
  List<Map<String, dynamic>> monthlyPlans = [];
  List<Map<String, dynamic>> yearlyPlans = [];

  @override
  void initState() {
    super.initState();
    fetchMembershipData();
  }
  
  // Helper method to get current data based on selected tab
  List<Map<String, dynamic>> get currentData {
    switch (selectedIndex) {
      case 0:
        return trailPlans;
      case 1:
        return monthlyPlans;
      case 2:
        return yearlyPlans;
      default:
        return trailPlans;
    }
  }
  
  // Fetch membership data from Supabase
  Future<void> fetchMembershipData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      // Get Trail plans
      final trailResponse = await Supabase.instance.client
          .from('memberships')
          .select()
          .eq('plan_type', 'trail')
          .order('expire_date');
      
      // Get Monthly plans  
      final monthlyResponse = await Supabase.instance.client
          .from('memberships')
          .select()
          .eq('plan_type', 'monthly')
          .order('expire_date');
      
      // Get Yearly plans
      final yearlyResponse = await Supabase.instance.client
          .from('memberships')
          .select()
          .eq('plan_type', 'yearly')
          .order('expire_date');
      
      setState(() {
        trailPlans = List<Map<String, dynamic>>.from(trailResponse);
        monthlyPlans = List<Map<String, dynamic>>.from(monthlyResponse);
        yearlyPlans = List<Map<String, dynamic>>.from(yearlyResponse);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load membership data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Membership", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF04101C),
        elevation: 0,
        // Removed refresh button from actions
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF04101C), Color(0xFF152536)],
          ),
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              if (selectedIndex < tabs.length - 1) {
                setState(() {
                  selectedIndex++;
                });
              }
            } else if (details.primaryVelocity! > 0) {
              if (selectedIndex > 0) {
                setState(() {
                  selectedIndex--;
                });
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab indicators
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: tabs.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String name = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = idx;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == idx
                                        ? Colors.blue
                                        : Colors.white60,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                width: 40,
                                height: 2,
                                color: selectedIndex == idx
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16), // Add spacing below tabs
              // Loading indicator or error message
              if (isLoading)
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                )
              else if (errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchMembershipData,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
                            // Data table - Now positioned at top with proper scrolling
              else
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey<int>(selectedIndex),
                      width: double.infinity,
                      alignment: Alignment.topCenter, // Keep aligned to top
                      child: Scrollbar(
                        thumbVisibility: true, // Always show vertical scrollbar
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            thumbVisibility: true, // Always show horizontal scrollbar
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: EdgeInsets.only(top: 0, bottom: 16, right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xFF334658), width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: DataTable(
                                    columnSpacing: 50,
                                    headingRowColor: MaterialStateColor.resolveWith(
                                        (states) => customGrey),
                                    dataRowColor: MaterialStateColor.resolveWith(
                                        (states) => Color(0xFF1A2D40)),
                                    border: TableBorder(
                                      horizontalInside:
                                          BorderSide(color: Color(0xFF334658), width: 1),
                                      verticalInside:
                                          BorderSide(color: Color(0xFF334658), width: 1),
                                    ),
                                    columns: [
                                      DataColumn(
                                          label: Text("Member Name", style: headerStyle)),
                                      DataColumn(
                                          label: Text("Plan Price", style: headerStyle)),
                                      DataColumn(
                                          label: Text("Expire Date", style: headerStyle)),
                                    ],
                                    rows: currentData.isEmpty
                                        ? [
                                            DataRow(cells: [
                                              DataCell(Text('No data available', 
                                                style: contentStyle)),
                                              DataCell(Text('')),
                                              DataCell(Text('')),
                                            ])
                                          ]
                                        : currentData.map((plan) {
                                            return DataRow(cells: [
                                              DataCell(Text(plan["member_name"], 
                                                style: contentStyle)),
                                              DataCell(Text("€ ${plan["price"]}", 
                                                style: contentStyle)),
                                              DataCell(Text(plan["expire_date"], 
                                                style: boldStyle)),
                                            ]);
                                          }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
// Text Styles
final TextStyle headerStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
final TextStyle contentStyle = TextStyle(fontSize: 14, color: Colors.white70);
final TextStyle boldStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);