// lib/features/profile/presentation/view/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart'; // Make sure this is still needed and correct
import 'package:thrill_quest/core/utils/url_utils.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_event.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_state.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

  /// Initializes controllers and animations. Called once when user data is loaded.
  void _initializeControllers(UserEntity user) {
    // Only initialize if controllers are null (first time user data is available)
    if (_nameController == null) {
      _nameController = TextEditingController(
        text: [
          user.fName,
          user.lName,
        ].where((name) => name != null && name.isNotEmpty).join(' '),
      );
      _emailController = TextEditingController(text: user.email);
      _phoneController = TextEditingController(text: user.phoneNo ?? '');

      _animationController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );
      _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController!,
          curve: Curves.easeOutCubic,
        ),
      );
      _animationController!.forward();
    } else {
      // Update controllers if they already exist to reflect changes
      // This is important if user data can change while the screen is active
      final currentFullName = [
        user.fName,
        user.lName,
      ].where((name) => name != null && name.isNotEmpty).join(' ');
      if (_nameController!.text != currentFullName) {
        _nameController!.text = currentFullName;
      }
      if (_emailController!.text != user.email) {
        _emailController!.text = user.email;
      }
      if (_phoneController!.text != (user.phoneNo ?? '')) {
        _phoneController!.text = user.phoneNo ?? '';
      }
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _nameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  void _pickImage() {
    context.read<ProfileViewModel>().add(PickProfileImageEvent());
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
            SaveChangesEvent(
              name: _nameController!.text,
              email: _emailController!.text,
              phone: _phoneController!.text,
              profileImage: context.read<ProfileViewModel>().state.imageFile, // Passes the File?
            ),
          );
    }
  }

  ImageProvider _getImageProvider(String profileImagePathOrUrl) {
    if (profileImagePathOrUrl.startsWith('http') || profileImagePathOrUrl.startsWith('https')) {
      return NetworkImage(profileImagePathOrUrl);
    } else if (profileImagePathOrUrl.startsWith('/') || profileImagePathOrUrl.startsWith('file://')) {
      // Handle local file paths
      final filePath = profileImagePathOrUrl.replaceFirst('file://', '');
      return FileImage(File(filePath));
    } else {
      // Fallback for paths that might be relative or malformed (treat as network for safety)
      debugPrint('Warning: Profile image path/URL "$profileImagePathOrUrl" is ambiguous. Attempting as network image.');
      return NetworkImage(UrlUtils.buildFullUrl(profileImagePathOrUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.saved) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text("Profile updated successfully"),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
          } else if (state.status == ProfileStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.error?.message ?? "An unknown error occurred",
                  ),
                  backgroundColor: Colors.red.shade600,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.user == null) {
            return const Center(child: Text("Could not load profile."));
          }

          _initializeControllers(state.user!);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green.shade600, Colors.green.shade400],
                    ),
                  ),
                  child: const FlexibleSpaceBar(
                    title: Text(
                      "My Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture Section
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: CircleAvatar(
                                        radius: 65,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage:
                                            state.imageFile != null // Use local file if picked
                                                ? FileImage(state.imageFile!)
                                                : (state.user!.profileImage != null &&
                                                        state.user!.profileImage!.isNotEmpty
                                                    ? _getImageProvider(
                                                        UrlUtils.buildFullUrl(state.user!.profileImage!),
                                                      )
                                                    : const AssetImage(
                                                        'assets/image/profile_placeholder.png',
                                                      )),
                                      ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      bottom: 8,
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                Colors.green.shade600,
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Personal Information Card
                            _buildSectionCard(
                              title: "Personal Information",
                              icon: Icons.person_outline,
                              children: [
                                _buildModernTextField(
                                  controller: _nameController!,
                                  label: "Full Name",
                                  icon: Icons.person_outline,
                                  type: TextInputType.name,
                                ),
                                const SizedBox(height: 20),
                                _buildModernTextField(
                                  controller: _emailController!,
                                  label: "Email Address",
                                  icon: Icons.email_outlined,
                                  type: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 20),
                                _buildModernTextField(
                                  controller: _phoneController!,
                                  label: "Phone Number",
                                  icon: Icons.phone_outlined,
                                  type: TextInputType.phone,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            // Save Button
                            Center(
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade600,
                                      Colors.green.shade400,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap:
                                        state.status == ProfileStatus.loading
                                            ? null
                                            : _saveProfile,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Center(
                                      child:
                                          state.status == ProfileStatus.loading
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.save_outlined,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Text(
                                                      "Save Changes",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.green.shade600, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType type,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (val) {
        if (label.contains("Email") && (val == null || !val.contains('@'))) {
          return "Enter a valid email address";
        } else if (label.contains("Phone") &&
            (val != null && val.isNotEmpty && val.length < 10)) {
          return "Enter a valid phone number";
        } else if (val == null || val.isEmpty) {
          if (label.contains("Name") || label.contains("Email")) {
            return "This field cannot be empty";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green.shade600, size: 20),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.green.shade400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
      ),
    );
  }
}