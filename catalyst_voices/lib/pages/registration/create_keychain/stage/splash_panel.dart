import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SplashPanel extends StatelessWidget {
  const SplashPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: context.l10n.accountCreationSplashTitle,
          subtitle: context.l10n.accountCreationSplashMessage,
        ),
        const Spacer(),
        VoicesFilledButton(
          child: Text(context.l10n.accountCreationSplashNextButton),
          onTap: () => RegistrationCubit.of(context).nextStep(),
        ),
      ],
    );
  }
}
