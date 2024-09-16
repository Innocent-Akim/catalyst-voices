import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return VoicesOutlinedButton(
          onTap: () => context
              .read<UserProfileBloc>()
              .add(const ToggleUserProfileEvent()),
          child: Text(
            switch (state) {
              VisitorUserProfileState() => 'Guest',
              ActiveUserProfileState() => state.user.name,
            },
          ),
        );
      },
    );
  }
}
