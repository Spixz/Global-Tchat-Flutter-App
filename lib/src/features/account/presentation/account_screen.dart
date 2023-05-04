import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/primary_button.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/colors.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_app_bar/account_app_bar.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/utils/async_value_ui.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTestState();
}

class _HomeTestState extends ConsumerState<AccountScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  String get email => _emailController.text;
  String get username => _usernameController.text;

  void selectAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'svg', 'bmp'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String filename = result.files.first.name;
      ref
          .read(accountControllerProvider.notifier)
          .sendFile('avatar/$filename', fileBytes!);
    }
  }

  void changeUserInformations(Map<String, dynamic> data) {
    ref.watch(accountControllerProvider.notifier).changeUserInformations(data);
  }

  void signOut() {
    ref.watch(accountControllerProvider.notifier).signOut();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(accountControllerProvider, (previous, state) {
      state.value.showAlertDialogOnError(context);
      state.value.showSnackBarOnSuccess(context);
    });

    var size = MediaQuery.of(context).size;
    final state = ref.watch(accountControllerProvider);

    _emailController.text = state.user?.email ?? '';
    _usernameController.text = state.user?.username ?? '';

    return Scaffold(
        appBar: const AccountAppBar(),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.9),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: CachedNetworkImage(
                      imageUrl: state.user?.profilePic ?? "",
                      // placeholder: (context, url) => const LoadingWidget(),
                      imageBuilder:
                          (BuildContext context, ImageProvider imageProvider) {
                        return GestureDetector(
                          onTap: () {
                            showImageViewer(context, imageProvider,
                                doubleTapZoomable: true,
                                swipeDismissible: true);
                          },
                          child: Stack(children: [
                            CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 100,
                              // fit: BoxFit.cover,
                            ),
                            Positioned(
                                bottom: 6,
                                right: 6,
                                child: CircleAvatar(
                                  backgroundColor: buttonColor,
                                  radius: 25,
                                  child: IconButton(
                                    color: Colors.white,
                                    splashRadius: 20,
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: () {
                                      selectAndSendFile();
                                    },
                                  ),
                                )),
                          ]),
                        );
                      },
                      errorWidget: (context, url, error) => const CircleAvatar(
                            radius: 100,
                            child: Icon(
                              Icons.person,
                              size: 100.0,
                              color: Colors.grey,
                            ),
                          )),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Username',
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: "Save",
                  isLoading: false,
                  onPressed: () => changeUserInformations({
                    'username': username,
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}
