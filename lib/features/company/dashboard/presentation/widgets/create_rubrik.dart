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
  final VoidCallback? onSaved;
  const CreateRubrikWidget({super.key, this.onSaved});

  @override
  State<CreateRubrikWidget> createState() => _CreateRubrikWidgetState();
}

class _CreateRubrikWidgetState extends State<CreateRubrikWidget> {
  List<String> texts = [];
  List<int> bobotList = [];
  final List<TextEditingController> _bobotControllers = [];
  bool _isSaved = false;

  int get totalBobot => bobotList.fold(0, (a, b) => a + b);

  @override
  void dispose() {
    for (final c in _bobotControllers) {
      c.dispose();
    }
    super.dispose();
  }

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
                                        _bobotControllers[index].text =
                                            bobotList[index].toString();
                                      }
                                      _isSaved = false;
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.minus,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
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
                                  SizedBox(height: 2),
                                  SizedBox(
                                    width: 52,
                                    child: TextField(
                                      controller: _bobotControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            bobotList[index] = 0;
                                            _isSaved = false;
                                          });
                                          return;
                                        }
                                        final int? parsed = int.tryParse(value);
                                        if (parsed == null || parsed < 0) return;
                                        final int newTotal =
                                            totalBobot - bobotList[index] + parsed;
                                        if (newTotal > 100) {
                                          context.showErrorToast(
                                            "Total bobot tidak boleh lebih dari 100%",
                                          );
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (mounted) {
                                              _bobotControllers[index].text =
                                                  bobotList[index].toString();
                                            }
                                          });
                                          return;
                                        }
                                        setState(() {
                                          bobotList[index] = parsed;
                                          _isSaved = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 6),
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
                                      _bobotControllers[index].text =
                                          bobotList[index].toString();
                                      _isSaved = false;
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
                                _bobotControllers.removeAt(index).dispose();
                                _isSaved = false;
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
                      _bobotControllers.add(TextEditingController(text: '0'));
                      _isSaved = false;
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
                  onTap: _isSaved || texts.isEmpty
                      ? null
                      : () {
                          context.read<ButtonNextCreateCubit>().updateValid(true);
                          context.showSuccessToast("Rubrik berhasil disimpan");
                          _saveRubrik();
                          setState(() {
                            _isSaved = true;
                          });
                          widget.onSaved?.call();
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_isSaved || texts.isEmpty)
                          ? Colors.grey.shade400
                          : AppColors.secondPositiveColor,
                    ),
                    child: Center(
                      child: Text(
                        _isSaved ? "Tersimpan ✓" : "Simpan",
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
