import 'package:flutter/material.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String userName = "";
  String userRole = "";
  String userImage = "";
  int productsCount = 0;
  int imagesCount = 0;
  double earnings = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString(AppConstants.UserName) ?? "User";
     
      // Load other data from your provider or API
      productsCount = 125; // Replace with actual data
      imagesCount = 320; // Replace with actual data
      earnings = 12.4; // Replace with actual data in thousands
    });
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Clear session data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Navigate to login page
      if (mounted) {
       AppRouteName.loginPage.pushAndRemoveUntil(context, (route)=> false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      
      // AppBar with Gradient
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildAppBar(),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Card
              _buildProfileCard(),
              
              const SizedBox(height: 20),
              
              // Settings Options
              _buildSettingsOptions(),
              
              const SizedBox(height: 40),
              
              // Powered By Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar with Gradient Background
 Widget _buildAppBar() {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: AppColor.greenGradient,
        image: const DecorationImage(
          image: AssetImage('assets/Appbar3.png'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Padding(
        // Remove SafeArea and use alignment similar to homepage
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  // Profile Card
  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Info Row
            Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColor.greenColor.withOpacity(0.1),
                  child: userImage.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            userImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person,
                              size: 35,
                              color: AppColor.greenColor,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 35,
                          color: AppColor.greenColor,
                        ),
                ),
                
                const SizedBox(width: 16),
                
                // Name and Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userRole,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Edit Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.greenColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppColor.greenColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(productsCount.toString(), "Products"),
                _buildVerticalDivider(),
                _buildStatItem(imagesCount.toString(), "Images"),
                _buildVerticalDivider(),
                _buildStatItem("₹ ${earnings}k", "Earnings"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Stat Item
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Vertical Divider
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  // Settings Options
  Widget _buildSettingsOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.account_balance_wallet,
            iconColor: AppColor.greenColor,
            title: "Earnings",
            onTap: () {
              // Navigate to earnings page
            },
          ),
          _buildDivider(),
          _buildSettingItemWithToggle(
            icon: Icons.notifications,
            iconColor: const Color(0xFFFFA726),
            title: "Notifications",
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.help_outline,
            iconColor: const Color(0xFF42A5F5),
            title: "Help & Support",
            onTap: () {
              // Navigate to help page
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.logout,
            iconColor: const Color(0xFF66BB6A),
            title: "Logout",
            onTap: _handleLogout,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  // Setting Item
  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  // Setting Item with Toggle
  Widget _buildSettingItemWithToggle({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.greenColor,
            activeTrackColor: AppColor.greenColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  // Divider
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[200],
      ),
    );
  }

  // Footer
  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          "Powered By",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(
          'assets/fulupo_logo.png', // Add your logo
          height: 40,
          errorBuilder: (_, __, ___) => Text(
            "Fulupo",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.greenColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Version 1.0.1.01",
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}