import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/features/authentication/presentation/widgets/second_bottom_sheet.dart';

class FirstSingupSheetContent extends StatelessWidget {
  final String methode;
  const FirstSingupSheetContent({super.key, required this.methode});

  void _openSecondSheet(BuildContext context) {
    Navigator.pop(context);
    AppBottomsheet.display(
      context,
      const SecondSingupSheetContent(methode: "daftar"),
      // BlocProvider.value(
      //   value: context.read<AuthStateCubit>(),
      //   child: const SecondSingupSheetContent(methode: "daftar"),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 30),
                Image.asset(AppImages.profile, width: 65, height: 65),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Lanjut dengan akun",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Dengan menekan Setuju, kamu menyetujui ',
                            ),
                            TextSpan(
                              text: 'Syarat dan Ketentuan',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' kami. Lihat cara kami mengelola data kamu di ',
                            ),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                BasicAppButton(
                  onPressed: () {
                    _openSecondSheet(context);
                  },
                  backgroundColor: Colors.black,
                  content: Text(
                    "Terima dan Lanjutkan",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentGeometry.topRight,
              child: IconButton(
                icon: SvgPicture.asset(
                  AppVectors.close,
                  width: 40.0,
                  height: 40.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  ElevatedButton(
//                   onPressed: () {
//                     _openSecondSheet(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero,
//                     ),
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: const Text(
//                     'Terima dan Lanjutkan',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ),
