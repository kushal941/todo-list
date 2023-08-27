import 'package:shimmer/shimmer.dart';
import 'package:todo/features/authentication/domain/models/user_model.dart';
import 'package:todo/features/authentication/presentation/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Custom drawer widget.
class CustomDrawer extends ConsumerWidget {
  /// Creates an instance of [CustomDrawer].
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel user = ref.watch(userModelStateProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // User profile
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Column(
              children: <Widget>[
                UserImage(photoURL: user.photoURL),
                const SizedBox(height: 10),
                Text(
                  user.displayName,
                ),
              ],
            ),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return ListTile(
                title: const Text('Logout'),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  ref.read(authSignOutCommandStateProvider).run();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// User image widget.
class UserImage extends StatefulWidget {
  /// Creates an instance of [UserImage].
  const UserImage({super.key, required this.photoURL});

  /// User photo URL.
  final String photoURL;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  /// Flag to check if image is loaded.
  bool _isImageLoaded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ClipOval(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10000),
          ),
          child: Stack(
            children: <Widget>[
              if (!_isImageLoaded) // Show shimmer if image is not loaded
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceVariant,
                  highlightColor: Theme.of(context).colorScheme.primary,
                  enabled: !_isImageLoaded,
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
              Image.network(
                widget.photoURL,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    // Image has finished loading
                    _isImageLoaded = true;
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
