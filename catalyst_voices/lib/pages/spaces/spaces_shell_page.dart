import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/pages/account/creation/get_started/account_create_dialog.dart';
import 'package:catalyst_voices/pages/spaces/drawer/spaces_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpacesShellPage extends StatefulWidget {
  final Space space;
  final Widget child;

  static final Map<Space, ShortcutActivator> _spacesShortcutsActivators = {
    Space.discovery: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit1,
    ),
    Space.workspace: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit2,
    ),
    Space.voting: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit3,
    ),
    Space.fundedProjects: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit4,
    ),
    Space.treasury: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyT,
    ),
  };

  const SpacesShellPage({
    super.key,
    required this.space,
    required this.child,
  });

  @override
  State<SpacesShellPage> createState() => _SpacesShellPageState();
}

class _SpacesShellPageState extends State<SpacesShellPage> {
  @override
  Widget build(BuildContext context) {
    final sessionBloc = context.watch<SessionBloc>();
    final isVisitor = sessionBloc.state is VisitorSessionState;
    final isUnlocked = sessionBloc.state is ActiveUserSessionState;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        for (final entry in SpacesShellPage._spacesShortcutsActivators.entries)
          entry.value: () => entry.key.go(context),
      },
      child: Scaffold(
        appBar: VoicesAppBar(
          leading: isVisitor ? null : const DrawerToggleButton(),
          automaticallyImplyLeading: false,
          actions: [
            SessionActionHeader(
              onGetStartedTap: _showAccountGetStarted,
            ),
            const SessionStateHeader(),
          ],
        ),
        drawer: isVisitor
            ? null
            : SpacesDrawer(
                space: widget.space,
                spacesShortcutsActivators:
                    SpacesShellPage._spacesShortcutsActivators,
                isUnlocked: isUnlocked,
              ),
        body: widget.child,
      ),
    );
  }

  Future<void> _showAccountGetStarted() async {
    final type = await AccountCreateDialog.show(context);
    if (type == null) {
      return;
    }

    if (mounted) {
      switch (type) {
        case AccountCreateType.createNew:
          _showCreateAccountFlow().ignore();
        case AccountCreateType.recover:
          _showRecoverAccountFlow().ignore();
      }
    }
  }

  Future<void> _showCreateAccountFlow() async {}

  Future<void> _showRecoverAccountFlow() async {}
}
