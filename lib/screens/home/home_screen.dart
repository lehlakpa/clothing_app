import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user;

          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AuthBloc>().add(const ProfileRequested());
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 20),

                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.image),
                  ),
                ),

                const SizedBox(height: 24),

                Center(
                  child: Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    '@${user.username}',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 32),

                _ProfileCard(
                  icon: Icons.person,
                  title: 'User ID',
                  value: user.id.toString(),
                ),

                _ProfileCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email,
                ),

                _ProfileCard(
                  icon: Icons.person_outline,
                  title: 'Username',
                  value: user.username,
                ),

                _ProfileCard(
                  icon: Icons.badge_outlined,
                  title: 'Gender',
                  value: user.gender,
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(const ProfileRequested());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
