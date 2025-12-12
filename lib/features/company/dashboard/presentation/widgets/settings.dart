import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/toogle/custom_toggle.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/editable_teks.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/rubrik.dart';

class SettingsWidget extends StatefulWidget {
  final String competitionId;
  const SettingsWidget({super.key, required this.competitionId});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final TextEditingController _judulController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isActive = true;
  List<String> texts = [];
  List<int> bobotList = [];
  int get totalBobot => bobotList.fold(0, (a, b) => a + b);
  int refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _judulController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _saveRubrik(BuildContext context) {
    final list = List.generate(
      texts.length,
      (i) => RubrikItemEntity(kriteria: texts[i], bobot: bobotList[i]),
    );

    context.read<CreateCompetitionCubit>().setRubrik(list);
  }

  void _displaySuccessToast(BuildContext context, String message) {
    MotionToast.success(
      title: const Text(
        "Success",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
    ).show(context);
  }

  void _displayErrorToast(BuildContext context, String message) {
    MotionToast.error(
      title: const Text(
        "Error",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(refreshKey),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                CreateCompetitionCubit()
                  ..fetchCompetitionById(widget.competitionId),
          ),
          BlocProvider(create: (context) => OrganizeCompetitionCubit()),
        ],
        child: Builder(
          builder: (providerContext) {
            return BlocConsumer<CreateCompetitionCubit, CreateCompetitionState>(
              listenWhen: (prev, curr) =>
                  prev.competition.status != curr.competition.status,
              listener: (context, state) {
                texts.clear();
                bobotList.clear();

                _judulController.text = state.competition.title;
                isActive = state.competition.status == "Dirilis";

                if (state.competition.rubrik.isNotEmpty) {
                  texts.addAll(state.competition.rubrik.map((e) => e.kriteria));
                  bobotList.addAll(
                    state.competition.rubrik.map((e) => e.bobot),
                  );
                }

                setState(() {});
              },
              builder: (context, state) {
                final DateTime deadlineDate = state.competition.deadline
                    .toDate();
                final String formattedDate = DateFormat(
                  'd MMM y',
                  'id_ID',
                ).format(deadlineDate);
                final isClosed = state.competition.status == "Ditutup";

                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ======= HEADER =======
                        const Text(
                          "Info Kompetisi",
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ======= INFO CARD =======
                        Container(
                          padding: const EdgeInsets.all(20),
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
                              // ======= JUDUL & STATUS =======
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Judul",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          state.competition.status == "Dirilis"
                                          ? AppColors.secondPositiveColor
                                          : state.competition.status ==
                                                "Disimpan"
                                          ? Colors.amber
                                          : AppColors.doveRedColor,
                                    ),
                                    child: Text(
                                      state.competition.status,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ======= TEXTFIELD JUDUL =======
                              TextField(
                                controller: _judulController,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.disableBackgroundButton,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.disableBackgroundButton,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                onChanged: (value) => providerContext
                                    .read<CreateCompetitionCubit>()
                                    .setTitle(value),
                              ),

                              const SizedBox(height: 30),

                              // ======= STATUS PUBLIKASI =======
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Status",
                                        style: TextStyle(
                                          color: AppColors.secondaryText,
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "Publikasi ke halaman peserta",
                                        style: TextStyle(
                                          color: AppColors.disableTextButton,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomToggle(
                                    value: isActive,
                                    onChanged: (val) {
                                      setState(() => isActive = val);
                                      providerContext
                                          .read<CreateCompetitionCubit>()
                                          .setStatus(
                                            val ? "Dirilis" : "Disimpan",
                                          );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // ======= DEADLINE =======
                              Text(
                                "Deadline",
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Divider(
                                color: AppColors.disableBackgroundButton,
                                thickness: 1,
                                height: 1,
                              ),

                              const SizedBox(height: 30),

                              // ======= RUBRIK =======
                              Text(
                                "Bobot penilaian(%)",
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),

                              ...List.generate(texts.length, (index) {
                                if (index >= bobotList.length) {
                                  return const SizedBox.shrink();
                                }
                                return _buildRubrikRow(index);
                              }),

                              const SizedBox(height: 30),

                              // ======= HADIAH =======
                              Text(
                                "Hadiah",
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: EditableTextItem(
                                      needWrapText: true,
                                      text: providerContext
                                          .watch<CreateCompetitionCubit>()
                                          .state
                                          .competition
                                          .rewardDescription,
                                      onChanged: (value) {
                                        providerContext
                                            .read<CreateCompetitionCubit>()
                                            .setRewardDescription(value);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      providerContext
                                          .read<CreateCompetitionCubit>()
                                          .setRewardDescription('');
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // ======= BUTTON SAVE / CANCEL =======
                              Row(
                                children: [
                                  Expanded(
                                    child: BasicAppButton(
                                      onPressed: () {
                                        setState(() => refreshKey++);
                                      },
                                      isBordered: true,
                                      borderColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      content: const Text(
                                        "Batal",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: BasicAppButton(
                                      onPressed:
                                          _judulController.text
                                              .trim()
                                              .isNotEmpty
                                          ? () async {
                                              _saveRubrik(providerContext);
                                              final competitionData =
                                                  providerContext
                                                      .read<
                                                        CreateCompetitionCubit
                                                      >()
                                                      .state
                                                      .competition;
                                              context
                                                  .read<
                                                    OrganizeCompetitionCubit
                                                  >()
                                                  .submitCompetition(
                                                    competitionData,
                                                  );

                                              _displaySuccessToast(
                                                context,
                                                "Perubahan berhasil disimpan",
                                              );
                                              Navigator.pop(context);
                                            }
                                          : null,
                                      backgroundColor:
                                          AppColors.thirdPositiveColor,
                                      content: const Center(
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

                              const SizedBox(height: 30),

                              // ======= DANGER ZONE =======
                              Text(
                                "Danger Zone",
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              _buildDangerZone(
                                providerContext,
                                state,
                                isClosed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRubrikRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: EditableTextItem(
              text: texts[index],
              onChanged: (value) => setState(() => texts[index] = value),
              needWrapText: true,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _buildBobotButton(
                  icon: CupertinoIcons.minus,
                  onTap: () {
                    setState(() {
                      if (bobotList[index] > 0) bobotList[index]--;
                    });
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    const Text(
                      "BOBOT",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        fontSize: 6,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      bobotList[index].toString(),
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                _buildBobotButton(
                  icon: CupertinoIcons.plus,
                  onTap: () {
                    final newTotal = totalBobot + 1;
                    if (newTotal > 100) {
                      _displayErrorToast(
                        context,
                        "Total bobot tidak boleh lebih dari 100%",
                      );
                      return;
                    }
                    setState(() => bobotList[index]++);
                  },
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
              icon: const Icon(CupertinoIcons.trash, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBobotButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
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
        onTap: onTap,
        child: Icon(icon, size: 23, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDangerZone(
    BuildContext context,
    CreateCompetitionState state,
    bool isClosed,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.thirdBackGroundButton, width: 2),
      ),
      child: Column(
        children: [
          BasicAppButton(
            onPressed: () {
              final cubit = context.read<CreateCompetitionCubit>();
              cubit.setStatus(isClosed ? "Dirilis" : "Ditutup");
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              );
              _displaySuccessToast(
                context,
                isClosed
                    ? "Kompetisi telah berhasil dibuka kembali"
                    : "Kompetisi telah berhasil ditutup",
              );
            },
            backgroundColor: isClosed
                ? AppColors.secondPositiveColor
                : Colors.white,
            isBordered: !isClosed,
            borderColor: isClosed ? null : AppColors.doveRedColor,
            content: Text(
              isClosed ? "Buka kompetisi" : "Tutup kompetisi",
              style: TextStyle(
                color: isClosed ? Colors.white : AppColors.doveRedColor,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "*Stop menerima submission baru. Bisa dibuka kembali.",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 25),
          BasicAppButton(
            onPressed: () {
              context.read<OrganizeCompetitionCubit>().deleteCompetitionById(
                state.competition.competitionId,
              );
              Navigator.pop(context);
            },
            backgroundColor: AppColors.doveRedColor,
            content: const Text(
              "Hapus kompetisi",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "*Menghapus kompetisi dan semua submission. Tidak dapat dibatalkan.",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
