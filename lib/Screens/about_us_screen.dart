// lib/Screens/about_us_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/science_background_painter.dart';

// Data model for a team member
class TeamMember {
  final String name;
  final String role;
  final IconData icon;
  final String description;
  final String link;

  const TeamMember({
    required this.name,
    required this.role,
    required this.icon,
    required this.description,
    required this.link,
  });
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // The team data, ported from your Swift code
  final List<TeamMember> teamMembers = const [
    TeamMember(
      name: "Mr. Sham Edward J",
      role: "Developer",
      icon: Icons.code_rounded,
      description: "Arjava India Tech Private Ltd., Chennai",
      link: "https://www.linkedin.com/in/sham-edward-5842b8287/"
    ),
    TeamMember(
      name: "Mr. Harrish Muthuram L M",
      role: "Designer",
      icon: Icons.design_services_rounded,
      description: "Arjava India Tech Private Ltd., Chennai",
      link: "https://www.linkedin.com/in/harrish-lm/"
    ),
    TeamMember(
      name: "Ms. Shruthi Vairavan",
      role: "Creative Spark",
      icon: Icons.lightbulb_rounded,
      description: "11th Grade, Eastlake High School, WA, USA",
      link: "https://www.linkedin.com/in/palani-vairavan-84b3921/"
    ),
    TeamMember(
      name: "Mr. Raghul Vijayan",
      role: "Test Engineer",
      icon: Icons.checklist_rounded,
      description: "Validation Test Lead, Cognizant, Chennai",
      link: "https://www.linkedin.com/in/raghul-vijayan/"
    ),
    TeamMember(
      name: "Mr. Siranjeevan C",
      role: "Data Aggregator",
      icon: Icons.data_usage_rounded,
      description: "I Year - BCA, Nachiappa Swamigal Arts & Science College, Karaikudi",
      link: "https://www.linkedin.com/company/arjavatech/posts/?feedView=all"
    ),
    TeamMember(
      name: "Mr. Pitchaimani Rajaram",
      role: "Development Manager",
      icon: Icons.business_center_rounded,
      description: "Arjava India Tech Private Ltd., Chennai",
      link: "https://www.linkedin.com/in/mani-rr-b93397201/"
    ),
    TeamMember(
      name: "Mr. Arivarasan V",
      role: "Mentor",
      icon: Icons.psychology_rounded,
      description: "Science Communicator, Tamil Nadu",
      link: "https://www.linkedin.com/company/arjavatech/posts/?feedView=all"
    ),
    TeamMember(
      name: "Dr. Meenakshi Sundaram",
      role: "Mentor",
      icon: Icons.psychology_rounded,
      description: "Applied Data Scientist, Computational Modeler, Intel Inc., Portland, USA",
      link: "https://www.linkedin.com/in/meenakshi-sundaram/"
    ),
    TeamMember(
      name: "Mr. Palani Vairavan",
      role: "Advisor",
      icon: Icons.star_rounded,
      description: "Engineering Manager(AWS), Amazon Inc., Seattle, USA",
      link: "https://www.linkedin.com/in/palani-vairavan-84b3921/"
    )
  ];

  // Helper function to launch URLs, accessible to all widgets on this screen
  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- THIS IS THE FIX: Calculate columns dynamically for responsiveness ---
    final screenWidth = MediaQuery.of(context).size.width;
    const maxCrossAxisExtent = 400.0;
    final crossAxisCount = (screenWidth / maxCrossAxisExtent).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF112240),
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          AnimationLimiter(
            child: CustomScrollView(
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                          child: Column(
                            children: [
                              const Text(
                                "Our Mission",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Arjava Technologies provides full stack IT products & solutions and UI/UX designing to make learning chemistry interactive and engaging for students everywhere.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Team Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 20),
                    child: const Text(
                      "Meet the Team",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                // Responsive Grid for Team Members
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverGrid.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: maxCrossAxisExtent,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 1.6, // Adjusted for better card shape
                    ),
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        // Pass the dynamically calculated column count
                        columnCount: crossAxisCount,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: TeamMemberCard(member: teamMembers[index], onLinkTap: _launchURL),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // New "Get in Touch" Section
                SliverToBoxAdapter(
                  child: AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                           padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
                           child: Column(
                             children: [
                                const Text(
                                  "Get in Touch",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "We'd love to hear from you! Connect with us on our social platforms.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), height: 1.5),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialButton(Icons.language, () => _launchURL("https://arjavatech.com/")),
                                    const SizedBox(width: 20),
                                    _buildSocialButton(Icons.people_alt_rounded, () => _launchURL("https://www.linkedin.com/company/arjavatech/")),
                                    const SizedBox(width: 20),
                                    _buildSocialButton(Icons.email_rounded, () => _launchURL("mailto:info@arjavatech.com")),
                                  ],
                                )
                             ],
                           ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.tealAccent, size: 32),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        padding: const EdgeInsets.all(16),
        side: BorderSide(color: Colors.white.withOpacity(0.2))
      ),
    );
  }
}

// A redesigned widget for displaying a team member
class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final Function(String) onLinkTap;
  const TeamMemberCard({super.key, required this.member, required this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(member.icon, color: Colors.tealAccent, size: 32),
              title: Text(
                member.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: InkWell(
                onTap: () => onLinkTap(member.link),
                child: Text(
                  member.role,
                  style: TextStyle(color: Colors.tealAccent.withOpacity(0.9), fontSize: 14),
                ),
              ),
            ),
            const Spacer(),
            Text(
              member.description,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

