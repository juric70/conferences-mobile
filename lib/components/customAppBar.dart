import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onDrawerIconPressed;
  final VoidCallback onBackIconPressed;
  final bool showBackIcon;
  const CustomAppBar({
    super.key,
    required this.onDrawerIconPressed,
    required this.onBackIconPressed,
    this.showBackIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
        child: showBackIcon
            ? const Center(
                child: Text(
                  'Andina slavna apliacija',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : const Text(
                'Andina  apliacija',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
      backgroundColor: const Color(0xFF2A2A2A).withOpacity(0.8),
      elevation: 2,
      shadowColor: Colors.grey[850],
      leading: showBackIcon
          ? IconButton(
              onPressed: onBackIconPressed,
              icon: const Icon(Icons.arrow_back),
            )
          : null,
      actions: [
        IconButton(
          onPressed: onDrawerIconPressed,
          icon: const Icon(Icons.menu),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
