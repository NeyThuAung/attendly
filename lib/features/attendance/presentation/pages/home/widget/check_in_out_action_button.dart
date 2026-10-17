import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/shared/styles/styles.dart';
import '../cubit/home_page_cubit.dart';

class CheckInOutActionButton extends StatelessWidget {
  const CheckInOutActionButton({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final isLoading = state is HomeInitial && state.isLoading;
    final isCheckedIn = state is HomeInitial && state.isCheckedIn;
    final location = state is HomeInitial ? state.currentLocation : null;

    final isDisabled = isLoading || location == null;
    final buttonColor = isCheckedIn ? Colors.red : Colors.green;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        onPressed: isDisabled ? null : () => cubit.toggleCheckInOut(),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Icon(
                isCheckedIn ? Icons.logout : Icons.login,
                color: Colors.white,
              ),
        label: Text(
          isLoading
              ? 'PROCESSING...'
              : (isCheckedIn ? 'CHECK OUT' : 'CHECK IN'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
