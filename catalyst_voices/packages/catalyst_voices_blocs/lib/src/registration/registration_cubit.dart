import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/keychain_creation_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/wallet_link_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the registration state.
final class RegistrationCubit extends Cubit<RegistrationState> {
  final KeychainCreationCubit _keychainCreationCubit;
  final WalletLinkCubit _walletLinkCubit;

  RegistrationCubit({
    required Downloader downloader,
  })  : _keychainCreationCubit = KeychainCreationCubit(
          downloader: downloader,
        ),
        _walletLinkCubit = WalletLinkCubit(),
        super(const RegistrationState()) {
    _keychainCreationCubit.stream.listen(_onKeychainStateDataChanged);
    _walletLinkCubit.stream.listen(_onWalletLinkStateDataChanged);
  }

  KeychainCreationManager get keychainCreation => _keychainCreationCubit;

  WalletLinkManager get walletLink => _walletLinkCubit;

  /// Returns [RegistrationCubit] if found in widget tree. Does not add
  /// rebuild dependency when called.
  static RegistrationCubit of(BuildContext context) {
    return context.read<RegistrationCubit>();
  }

  @override
  Future<void> close() {
    _keychainCreationCubit.close();
    _walletLinkCubit.close();
    return super.close();
  }

  void createNewKeychainStep() {
    final nextStep = _nextStep(from: const CreateKeychainStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void recoverKeychainStep() {
    final nextStep = _nextStep(from: const RecoverStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void chooseOtherWallet() {
    _goToStep(const WalletLinkStep(stage: WalletLinkStage.selectWallet));
  }

  void changeRoleSetup() {
    _goToStep(const WalletLinkStep(stage: WalletLinkStage.rolesChooser));
  }

  void nextStep() {
    final nextStep = _nextStep();
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void previousStep() {
    final previousStep = _previousStep();
    if (previousStep != null) {
      _goToStep(previousStep);
    }
  }

  RegistrationStep? _nextStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    RegistrationStep nextKeychainStep() {
      final step = state.step;

      // if current step is not from create keychain just return current one
      if (step is! CreateKeychainStep) {
        return const CreateKeychainStep();
      }

      // if there is no next step from keychain creation go to finish account.
      final nextStage = step.stage.next;
      return nextStage != null
          ? CreateKeychainStep(stage: nextStage)
          : const FinishAccountCreationStep();
    }

    RegistrationStep nextWalletLinkStep() {
      final step = state.step;

      // if current step is not from create WalletLink just return current one
      if (step is! WalletLinkStep) {
        return const WalletLinkStep();
      }

      // if there is no next step from wallet link go to account completed.
      final nextStage = step.stage.next;
      return nextStage != null
          ? WalletLinkStep(stage: nextStage)
          : const AccountCompletedStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverStep() => throw UnimplementedError(),
      CreateKeychainStep() => nextKeychainStep(),
      FinishAccountCreationStep() => const WalletLinkStep(),
      WalletLinkStep() => nextWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  RegistrationStep? _previousStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    /// Nested function. Responsible only for keychain steps logic.
    RegistrationStep previousKeychainStep() {
      final step = state.step;

      final previousStep =
          step is CreateKeychainStep ? step.stage.previous : null;

      return previousStep != null
          ? CreateKeychainStep(stage: previousStep)
          : const GetStartedStep();
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationStep previousWalletLinkStep() {
      final step = state.step;

      final previousStep = step is WalletLinkStep ? step.stage.previous : null;

      return previousStep != null
          ? WalletLinkStep(stage: previousStep)
          : const FinishAccountCreationStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverStep() => null,
      CreateKeychainStep() => previousKeychainStep(),
      FinishAccountCreationStep() => null,
      WalletLinkStep() => previousWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  void _goToStep(RegistrationStep step) {
    emit(state.copyWith(step: step));
  }

  void _onKeychainStateDataChanged(KeychainStateData data) {
    emit(state.copyWith(keychainStateData: data));
  }

  void _onWalletLinkStateDataChanged(WalletLinkStateData data) {
    emit(state.copyWith(walletLinkStateData: data));
  }
}
