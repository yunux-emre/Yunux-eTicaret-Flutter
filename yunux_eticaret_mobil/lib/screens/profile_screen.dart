import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mobil_projesi/models/user_model.dart';
import 'package:mobil_projesi/providers/theme_provider.dart';
import 'package:mobil_projesi/providers/user_provider.dart';
import 'package:mobil_projesi/screens/auth/login.dart';
import 'package:mobil_projesi/screens/inner_screen/orders_screen.dart';
import 'package:mobil_projesi/screens/inner_screen/viewed_recently.dart';
import 'package:mobil_projesi/screens/inner_screen/wishlist.dart';
import 'package:mobil_projesi/screens/loading_manager.dart';
import 'package:mobil_projesi/services/assets_manager.dart';
import 'package:mobil_projesi/services/my_app_functions.dart';
import 'package:mobil_projesi/widgets/app_name_text.dart';
import 'package:mobil_projesi/widgets/subtitle_text.dart';
import 'package:mobil_projesi/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;
  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: const AppNameTextWidget(),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: user == null ? true : false,
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: TitlesTextWidget(
                    label: "Tüm özellikler için giriş yap",
                  ),
                ),
              ),
              userModel == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.background,
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child: userModel!.userImage.trim().isEmpty
                                  ? Icon(
                                      Icons.person,
                                      size: 34,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    )
                                  : Image.network(
                                      userModel!.userImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 34,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            );
                                          },
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitlesTextWidget(label: userModel!.userName),
                                  const SizedBox(height: 6),
                                  SubtitleTextWidget(
                                    label: userModel!.userEmail,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    const TitlesTextWidget(label: "Genel"),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Tüm siparişler",
                        imagePath: AssetsManager.orderSvg,
                        function: () {
                          Navigator.pushNamed(
                            context,
                            OrdersScreenFree.routeName,
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Beğendiklerim",
                        imagePath: AssetsManager.wishlistSvg,
                        function: () {
                          Navigator.pushNamed(context, WishlistScreen.routName);
                        },
                      ),
                    ),
                    CustomListTile(
                      text: "Son görüntülenenler",
                      imagePath: AssetsManager.recent,
                      function: () {
                        Navigator.pushNamed(
                          context,
                          ViewedRecentlyScreen.routName,
                        );
                      },
                    ),
                    CustomListTile(
                      text: "Adres",
                      imagePath: AssetsManager.address,
                      function: () {},
                    ),
                    const SizedBox(height: 6),
                    const Divider(thickness: 1),
                    const SizedBox(height: 6),
                    const TitlesTextWidget(label: "Ayarlar"),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      secondary: Image.asset(AssetsManager.theme, height: 34),
                      title: Text(
                        themeProvider.getIsDarkTheme
                            ? "Karanlık mod"
                            : "Aydınlık mod",
                      ),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(themeValue: value);
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  icon: Icon(user == null ? Icons.login : Icons.logout),
                  label: Text(user == null ? "Giriş Yap" : "Çıkış Yap"),
                  onPressed: () async {
                    if (user == null) {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    } else {
                      await MyAppFunctions.showErrorOrWarningDialog(
                        context: context,
                        subtitle: "Çıkmak istediğine emin misin?",
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(
                            context,
                            LoginScreen.routeName,
                          );
                        },
                        isError: false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(imagePath, height: 34),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
