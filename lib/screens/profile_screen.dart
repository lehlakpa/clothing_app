import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_event.dart';
import 'package:clothing_app/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothing_app/constants/constants_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ---------- Top-right decorative circle ----------
            Positioned(
              top: -90,
              right: -90,
              child: _buildDecoCircle(size: 220),
            ),

            // ---------- Bottom-left decorative circle ----------
            Positioned(
              bottom: -100,
              left: -100,
              child: _buildDecoCircle(size: 260),
            ),

            // ---------- Content ----------
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  final profile = state.profile;
                  return _buildProfileContent(context, profile);
                }

                if (state is AuthError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, Map profile) {
    final String username = '${profile['username'] ?? ''}';
    final String email = '${profile['email'] ?? ''}';
    final String firstName = '${profile['firstName'] ?? ''}';
    final String lastName = '${profile['lastName'] ?? ''}';
    final String id = '${profile['id'] ?? ''}';
    final String initials = _initials(firstName, lastName, username);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        children: [
          // Top bar: title + logout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: ConstantsColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
                icon: const Icon(Icons.logout, color: ConstantsColors.navy),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Avatar
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ConstantsColors.bannerBlue, ConstantsColors.navy],
              ),
              boxShadow: [
                BoxShadow(
                color: ConstantsColors.navy.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            (firstName.isNotEmpty || lastName.isNotEmpty)
                ? '$firstName $lastName'.trim()
                : username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ConstantsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@$username',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),

          const SizedBox(height: 28),

          // Info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: ConstantsColors.cardBackground,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.badge_outlined, 'ID', id),
                _divider(),
                _buildInfoRow(Icons.person_outline, 'Username', username),
                _divider(),
                _buildInfoRow(Icons.email_outlined, 'Email', email),
                _divider(),
                _buildInfoRow(
                  Icons.account_circle_outlined,
                  'Name',
                  '$firstName $lastName'.trim(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    indent: 20,
    endIndent: 20,
    color: Colors.grey.shade200,
  );

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ConstantsColors.navy.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: ConstantsColors.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: ConstantsColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String first, String last, String username) {
    if (first.isNotEmpty || last.isNotEmpty) {
      final f = first.isNotEmpty ? first[0] : '';
      final l = last.isNotEmpty ? last[0] : '';
      return (f + l).toUpperCase();
    }
    if (username.isNotEmpty) {
      return username.substring(0, username.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '?';
  }

  // Decorative circle: navy base + white icy translucent shading layer
  Widget _buildDecoCircle({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ConstantsColors.navy,
            ),
          ),
          Positioned(
            left: size * 0.18,
            top: size * 0.18,
            child: Container(
              width: size * 0.82,
              height: size * 0.82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.55),
                    Colors.white.withOpacity(0.10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
