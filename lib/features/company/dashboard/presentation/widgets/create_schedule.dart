import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/editable_teks.dart';

class CreateScheduleWidget extends StatefulWidget {
  const CreateScheduleWidget({super.key});

  @override
  State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
}

class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<CreateCompetitionCubit, CreateCompetitionState>(
        builder: (context, state) {
          final cubit = context.read<CreateCompetitionCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Langkah 3 dari 3",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black,
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
              SizedBox(height: 10),
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
                    Text(
                      "Tanggal mulai",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryText,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hari",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (AppColors.thirdBackGroundButton),
                                  Color(0xFFD2D2D2),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildDatePickerField(
                              context: context,
                              hint: cubit.pickedDate != null
                                  ? "${cubit.pickedDate!.day}/${cubit.pickedDate!.month}/${cubit.pickedDate!.year}"
                                  : "HH/BB/TT",
                              onDatePicked: (date) {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setCreatedDate(date);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (AppColors.thirdBackGroundButton),
                                  Color(0xFFD2D2D2),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildTimePickerField(
                              context: context,
                              hint: cubit.pickedTime != null
                                  ? "${cubit.pickedTime!.hour.toString().padLeft(2, '0')}:${cubit.pickedTime!.minute.toString().padLeft(2, '0')}"
                                  : "JJ:MM",
                              onTimePicked: (time) {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setCreatedTime(time);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tanggal tutup",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryText,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hari",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (AppColors.thirdBackGroundButton),
                                  Color(0xFFD2D2D2),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildDatePickerField(
                              context: context,
                              hint: cubit.deadlineDate != null
                                  ? "${cubit.deadlineDate!.day}/${cubit.deadlineDate!.month}/${cubit.deadlineDate!.year}"
                                  : "HH/BB/TT",
                              onDatePicked: (date) {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setDeadlineDate(date);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (AppColors.thirdBackGroundButton),
                                  Color(0xFFD2D2D2),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildTimePickerField(
                              context: context,
                              hint: cubit.deadlineTime != null
                                  ? "${cubit.deadlineTime!.hour.toString().padLeft(2, '0')}:${cubit.deadlineTime!.minute.toString().padLeft(2, '0')}"
                                  : "JJ:MM",
                              onTimePicked: (time) {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setDeadlineTime(time);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Hadiah",
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: EditableTextItem(
                            needWrapText: true,
                            text: context
                                .watch<CreateCompetitionCubit>()
                                .state
                                .competition
                                .rewardDescription,

                            onChanged: (value) {
                              context
                                  .read<CreateCompetitionCubit>()
                                  .setRewardDescription(value);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context
                                .read<CreateCompetitionCubit>()
                                .setRewardDescription('');
                          },
                          icon: Icon(CupertinoIcons.trash, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTimePickerField({
    required BuildContext context,
    required String hint,
    required Function(TimeOfDay) onTimePicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (time != null) onTimePicked(time);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [(AppColors.thirdBackGroundButton), Color(0xFFD2D2D2)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
        child: Text(
          hint,
          style: const TextStyle(
            color: AppColors.secondaryBackgroundButton,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildDatePickerField({
    required BuildContext context,
    required String hint,
    required Function(DateTime) onDatePicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );

        if (date != null) onDatePicked(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [(AppColors.thirdBackGroundButton), Color(0xFFD2D2D2)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
        child: Text(
          hint,
          style: const TextStyle(
            color: AppColors.secondaryBackgroundButton,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
// class CreateScheduleWidget extends StatefulWidget {
//   const CreateScheduleWidget({super.key});
//   @override
//   State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
// }
// class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {
//   final TextEditingController _hariMulai = TextEditingController();
//   final TextEditingController _jamMulai = TextEditingController();
//   final TextEditingController _hariTutup = TextEditingController();
//   final TextEditingController _jamTutup = TextEditingController();
//   // final TextEditingController _zonaWaktu = TextEditingController();
//   final TextEditingController _hadiah = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     debugPrint('opo maneh iki');
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Langkah 3 dari 3",
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: AppColors.secondaryText,
//           ),
//         ),
//         SizedBox(height: 5),
//         Row(
//           children: List.generate(3, (index) {
//             return Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
//                 height: 8,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.black,
//                 ),
//               ),
//             );
//           }),
//         ),
//         SizedBox(height: 20),
//         Text(
//           "Kriteria Penilaian",
//           style: TextStyle(
//             fontFamily: 'JetBrainsMono',
//             fontWeight: FontWeight.w800,
//             fontSize: 18,
//           ),
//         ),
//         SizedBox(height: 10),
//         Container(
//           padding: EdgeInsets.all(16),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: AppColors.thirdBackGroundButton,
//               width: 2,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Tanggal mulai",
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.secondaryText,
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Hari",
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             (AppColors.thirdBackGroundButton),
//                             Color(0xFFD2D2D2),
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: TextField(
//                         controller: _hariMulai,
//                         decoration: InputDecoration(
//                           hintText: "HH/BB/TT",
//                           hintStyle: TextStyle(
//                             color: AppColors.secondaryText,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             (AppColors.thirdBackGroundButton),
//                             Color(0xFFD2D2D2),
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: TextField(
//                         controller: _jamMulai,
//                         decoration: InputDecoration(
//                           hintText: "JJ/MM",
//                           hintStyle: TextStyle(
//                             color: AppColors.secondaryText,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "Tanggal tutup",
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.secondaryText,
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Hari",
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             (AppColors.thirdBackGroundButton),
//                             Color(0xFFD2D2D2),
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: TextField(
//                         controller: _hariTutup,
//                         decoration: InputDecoration(
//                           hintText: "HH/BB/TT",
//                           hintStyle: TextStyle(
//                             color: AppColors.secondaryText,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             (AppColors.thirdBackGroundButton),
//                             Color(0xFFD2D2D2),
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: TextField(
//                         controller: _jamTutup,
//                         decoration: InputDecoration(
//                           hintText: "JJ/MM",
//                           hintStyle: TextStyle(
//                             color: AppColors.secondaryText,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // SizedBox(height: 20),
//               // Text(
//               //   "Zona Waktu",
//               //   style: TextStyle(
//               //     fontFamily: 'Inter',
//               //     fontWeight: FontWeight.w700,
//               //     color: AppColors.secondaryText,
//               //     fontSize: 16,
//               //   ),
//               // ),
//               // SizedBox(height: 10),
//               // Container(
//               //   height: 50,
//               //   width: double.infinity,
//               //   decoration: BoxDecoration(
//               //     gradient: LinearGradient(
//               //       colors: [
//               //         (AppColors.thirdBackGroundButton),
//               //         Color(0xFFD2D2D2),
//               //       ],
//               //       begin: Alignment.bottomCenter,
//               //       end: Alignment.topCenter,
//               //     ),
//               //     borderRadius: BorderRadius.circular(12),
//               //   ),
//               //   child: TextField(
//               //     controller: _zonaWaktu,
//               //     decoration: InputDecoration(
//               //       hintText: "JJ/MM",
//               //       hintStyle: TextStyle(
//               //         color: AppColors.secondaryText,
//               //         fontFamily: 'Inter',
//               //         fontWeight: FontWeight.w500,
//               //       ),
//               //       border: OutlineInputBorder(
//               //         borderRadius: BorderRadius.circular(8),
//               //         borderSide: BorderSide.none,
//               //       ),
//               //       contentPadding: EdgeInsets.symmetric(
//               //         horizontal: 12,
//               //         vertical: 12,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               SizedBox(height: 20),
//               Text(
//                 "Hadiah",
//                 style: TextStyle(
//                   color: AppColors.secondaryText,
//                   fontSize: 18,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             (AppColors.thirdBackGroundButton),
//                             Color(0xFFD2D2D2),
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: TextField(
//                         controller: _hadiah,
//                         onChanged: (value) {
//                           context
//                               .read<CreateCompetitionCubit>()
//                               .setRewardDescription(value);
//                         },
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(
//                             color: AppColors.secondaryText,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: Icon(CupertinoIcons.trash, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
  // Widget gradientInput({
  //   required TextEditingController controller,
  //   required String hint,
  // }) {
  //   return Container(
  //     height: 50,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [AppColors.thirdBackGroundButton, Color(0xFFD2D2D2)],
  //         begin: Alignment.bottomCenter,
  //         end: Alignment.topCenter,
  //       ),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: TextField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         hintText: hint,
  //         hintStyle: TextStyle(
  //           color: AppColors.secondaryText,
  //           fontFamily: 'Inter',
  //           fontWeight: FontWeight.w500,
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: BorderSide.none,
  //         ),
  //         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //       ),
  //     ),
  //   );
  // }
  // Widget formTitle(String text) {
  //   return Text(
  //     text,
  //     style: TextStyle(
  //       fontFamily: 'Inter',
  //       fontWeight: FontWeight.w700,
  //       color: AppColors.secondaryText,
  //       fontSize: 16,
  //     ),
  //   );
  // }
