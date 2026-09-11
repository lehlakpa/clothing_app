import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_event.dart';
import 'package:clothing_app/bloc/auth_state.dart';
import 'package:clothing_app/widgets/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(
        title: const Text('Profile'),

        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final profile = state.profile;

            return Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Text('ID: ${profile['id']}'),

                  Text('Username: ${profile['username']}'),

                  Text('Email: ${profile['email']}'),

                  Text(
                    'Name: ${profile['firstName']} '
                    '${profile['lastName']}',
                  ),
                ],
              ),
            );
          }

          if (state is AuthError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
