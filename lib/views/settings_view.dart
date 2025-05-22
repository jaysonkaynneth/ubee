import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsView extends GetView {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.systemGroupedBackground,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildSection(
                title: 'General',
                children: [
                  CupertinoListTile(
                    title: const Text('About'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {},
                  ),
                  CupertinoListTile(
                    title: const Text('Help'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection(
                title: 'Account',
                children: [
                  CupertinoListTile(
                    title: const Text('Profile'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {},
                  ),
                  CupertinoListTile(
                    title: const Text('Privacy'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: CupertinoColors.systemBlue,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
