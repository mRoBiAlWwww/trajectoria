import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/button_next_create_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_cubit.dart';
import 'package:trajectoria/common/widgets/textfield/editable_teks.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/rubrik.dart';

class CreateRubrikWidget extends StatefulWidget {
  const CreateRubrikWidget({super.key});

  @override
  State<CreateRubrikWidget> createState() => _CreateRubrikWidgetState();
}

class _CreateRubrikWidgetState extends State<CreateRubrikWidget> {
  List<String> texts = [];
  List<int> bobotList = [];

  int get totalBobot => bobotList.fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Langkah 2 dari 3",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: List.generate(3, (index) {
              final colors = [
                Colors.black,
                Colors.black,
                AppColors.thirdBackGroundButton,
              ];

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colors[index],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          Text(
            "Kriteria Penilaian",
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.thirdBackGroundButton,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "Bobot penilaian(%)",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: 15),
                ...List.generate(
                  texts.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: EditableTextItem(
                            needWrapText: true,
                            text: texts[index],
                            onChanged: (value) {
                              setState(() {
                                texts[index] = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(25, 0, 0, 0),
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () {
                                    setState(() {
                                      if (bobotList[index] > 0) {
                                        bobotList[index]--;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.minus,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                    "BOBOT",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 6,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bobotList[index].toString(),
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(25, 0, 0, 0),
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () {
                                    int newTotal = totalBobot + 1;

                                    if (newTotal > 100) {
                                      context.showErrorToast(
                                        "Total bobot tidak boleh lebih dari 100%",
                                      );
                                      return;
                                    }

                                    setState(() {
                                      bobotList[index]++;
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.plus,
                                    size: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                texts.removeAt(index);
                                bobotList.removeAt(index);
                              });
                            },
                            icon: Icon(CupertinoIcons.trash, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      texts.add("Kriteria ${texts.length + 1}");
                      bobotList.add(0);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Color(0XFFB2B2B2), Color(0xFF242424)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Tambah Kriteria",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    texts.isNotEmpty
                        ? context.read<ButtonNextCreateCubit>().updateValid(
                            true,
                          )
                        : null;
                    context.showSuccessToast("Rubrik berhasil disimpan");
                    _saveRubrik();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.secondPositiveColor,
                    ),
                    child: Center(
                      child: Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveRubrik() {
    final list = List.generate(
      texts.length,
      (i) => RubrikItemEntity(kriteria: texts[i], bobot: bobotList[i]),
    );

    context.read<CreateCompetitionCubit>().setRubrik(list);
  }
}
