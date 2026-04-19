import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../logic/blocs/auth/auth_event.dart';
import '../../../logic/blocs/auth/auth_state.dart';

class ResumingSessionPage extends StatelessWidget {
  const ResumingSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMacOS = Theme.of(context).platform == TargetPlatform.macOS;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          minimum: EdgeInsets.only(top: isMacOS ? 30.0 : 0.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final name = state.resumingName ?? '';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Icon(Icons.lock_open_rounded,
                      size: 72, color: Colors.white),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name.isNotEmpty ? name : 'Signing in…',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(CancelResuming());
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
