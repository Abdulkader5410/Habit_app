import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/add_habit/add_habit_cubit.dart';
import 'package:untitled/bloc/add_habit/add_habit_state.dart';
import 'package:untitled/bloc/edit%20hab/edit_habit_cubit.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/screen/add_habit/textform_widget.dart';
import 'package:untitled/screen/home/home_screen.dart';

class AddHabitScreen extends StatefulWidget {
  int? idUser;

  String? title, desc, goal, priority;
  int? habitType;
  int? idHabit;
  final bool isUpdate;

  AddHabitScreen(
      {super.key,
      this.idUser,
      this.desc,
      this.goal,
      this.habitType,
      required this.isUpdate,
      this.priority,
      this.idHabit,
      this.title});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  Future<List<Map<String, dynamic>>> getHabitTypes() async {
    final hts = await DatabaseHelper.getHabitTypes();

    List<Map<String, dynamic>> habitTypes = [];

    hts.forEach((ht) {
      habitTypes.add(ht);
    });

    return habitTypes;
  }

  int choisIndex = 0;
  String? selectedItem;

  PageController pageController = PageController();

  String? sDate;
  String? eDate;

  Future<void> getStartDateSelected(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? darkColor
                  : lightColor,
              borderRadius: BorderRadius.circular(25)),
          height: 300,
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2040, 5, 5),
            onDateChanged: (value) {
              widget.isUpdate
                  ? context.read<EditHabitCubit>().startDate = value
                  : context.read<AddHabitCubit>().startDate = value;

              setState(() {
                sDate = "$value";
              });
            },
          ),
        );
      },
    );
  }

  Future<void> getEndDateSelected(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? darkColor
                  : lightColor,
              borderRadius: BorderRadius.circular(25)),
          height: 300,
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2040, 5, 5),
            onDateChanged: (value) {
              widget.isUpdate
                  ? context.read<EditHabitCubit>().endDate = value
                  : context.read<AddHabitCubit>().endDate = value;

              setState(() {
                eDate = "$value";
              });
            },
          ),
        );
      },
    );
  }

  Future<void> showNotificationDioalg(BuildContext context, int count) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? darkColor
              : lightColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                height: 350,
                child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                          onTap: () {
                            showTimeDioalg(context);
                          },
                          child: const Text("12:00 AM")),
                    );
                  },
                ),
              )
            ],
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.check))
          ],
          title: const Text("Add Notifications"),
        );
      },
    );
  }

  Future<void> showTimeDioalg(BuildContext context) async {
    final TimeOfDay? x = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (x != null) {
      widget.isUpdate
          ? context.read<EditHabitCubit>().timeNotifi = x.format(context)
          : context.read<AddHabitCubit>().timeNotifi = x.format(context);

      widget.isUpdate
          ? context
              .read<EditHabitCubit>()
              .timeNotifiList
              .add(context.read<EditHabitCubit>().timeNotifi!)
          : context
              .read<AddHabitCubit>()
              .timeNotifiList
              .add(context.read<AddHabitCubit>().timeNotifi!);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      "Title of habit",
      "Goal of habit",
      "Description of habit"
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.isUpdate ? "Edit habit" : "Create habit",
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: lightColor),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              widget.isUpdate
                  ? context
                      .read<EditHabitCubit>()
                      .editHabit(widget.idUser!, widget.idHabit!)
                  : context.read<AddHabitCubit>().addHabit(widget.idUser!);

              context.read<AddHabitCubit>().descController.text = "";
              context.read<AddHabitCubit>().titleController.text = "";
              context.read<AddHabitCubit>().goalController.text = "";

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      userId: widget.idUser,
                    ),
                  ));
            },
            child: const Icon(
              size: 30,
              Icons.check,
              color: lightColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: BlocConsumer<AddHabitCubit, AddHabitState>(
        listener: (context, state) {
          if (state is AddHabitError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errMsg)));
          } else if (state is AddHabitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Added Successfully")));

            Future.delayed(
              const Duration(seconds: 1),
              () {
                Navigator.pop(context);
              },
            );
          }
        },
        builder: (context, state) {
          if (state is AddHabitLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: primaryColor, strokeWidth: 2),
            );
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? darkColor
                            : lightColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            textAlign: TextAlign.center,
                            "Habit Type",
                            maxLines: 2,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          width: MediaQuery.sizeOf(context).width - 148,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: DatabaseHelper.getHabitTypes(),
                            builder: (context, snapshot) {
                              final hts = snapshot.data;
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: hts!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final ht = hts[index];

                                    return GestureDetector(
                                      onTap: () {
                                        if (widget.habitType == ht['id_ht']) {
                                          setState(() {
                                            choisIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            choisIndex = index;
                                          });
                                        }
                                        widget.isUpdate
                                            ? context
                                                .read<EditHabitCubit>()
                                                .idHt = ht['id_ht']
                                            : context
                                                .read<AddHabitCubit>()
                                                .idHt = ht['id_ht'];
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 12),
                                        width: 70,
                                        height: 62,
                                        decoration: BoxDecoration(
                                            border: choisIndex == index
                                                ? Border.all(
                                                    color: primaryColor,
                                                    width: 3)
                                                : null,
                                            color: Color(ht['color'])
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                textAlign: TextAlign.center,
                                                "${ht['name']}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                            Icon(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? lightColor
                                                  : darkColor,
                                              IconData(ht['icon'],
                                                  fontFamily: 'MaterialIcons'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Container(
                                  color: Colors.red,
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: widget.isUpdate
                        ? context.read<EditHabitCubit>().addHabitForm
                        : context.read<AddHabitCubit>().addHabitForm,
                    child: SizedBox(
                      height: 240,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return TextFormWidget(
                              text: widget.isUpdate && index == 0
                                  ? widget.title
                                  : index == 1
                                      ? widget.goal
                                      : widget.desc,
                              controller: widget.isUpdate
                                  ? index == 0
                                      ? context
                                          .read<EditHabitCubit>()
                                          .titleController
                                      : index == 1
                                          ? context
                                              .read<EditHabitCubit>()
                                              .goalController
                                          : context
                                              .read<EditHabitCubit>()
                                              .descController
                                  : index == 0
                                      ? context
                                          .read<AddHabitCubit>()
                                          .titleController
                                      : index == 1
                                          ? context
                                              .read<AddHabitCubit>()
                                              .goalController
                                          : context
                                              .read<AddHabitCubit>()
                                              .descController,
                              name: titles[index]);
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), border: null),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          border: null,
                          enabledBorder: null,
                          focusedBorder: null,
                          disabledBorder: null),
                      iconSize: 30,
                      hint: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.flag_outlined,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Proirity",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      value: selectedItem,
                      items: <String>['high', 'medium', 'low']
                          .map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        selectedItem = value;
                        widget.isUpdate
                            ? context.read<EditHabitCubit>().priority =
                                selectedItem
                            : context.read<AddHabitCubit>().priority =
                                selectedItem;
                        print("VALUE >>>>>> $selectedItem");
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await getStartDateSelected(context);
                              },
                              child:
                                  const Icon(size: 30, Icons.calendar_month)),
                          Text("   Start date",
                              style: Theme.of(context).textTheme.displayMedium),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          sDate == null
                              ? '2024/11/11'
                              : sDate!.split(' ').first,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await getEndDateSelected(context);
                              },
                              child:
                                  const Icon(size: 30, Icons.calendar_month)),
                          Text("   End date",
                              style: Theme.of(context).textTheme.displayMedium),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          eDate == null
                              ? '2024/12/12'
                              : eDate!.split(' ').first,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontWeight: FontWeight.w900,
                                color: primaryColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Number of reminders\n for this habit",
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: const Icon(
                                  size: 30, Icons.keyboard_arrow_left_rounded)),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: PageView.builder(
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                widget.isUpdate
                                    ? context
                                        .read<EditHabitCubit>()
                                        .countNotifi = index + 1
                                    : context
                                        .read<AddHabitCubit>()
                                        .countNotifi = index + 1;
                                print(
                                    "COUNT >>>>>> ${context.read<AddHabitCubit>().countNotifi}");
                                return Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                );
                              },
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                                log("message ${pageController.page}");
                              },
                              child: const Icon(
                                  size: 30,
                                  Icons.keyboard_arrow_right_rounded)),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: GestureDetector(
                              onTap: () {
                                showNotificationDioalg(
                                    context,
                                    widget.isUpdate
                                        ? context
                                            .read<EditHabitCubit>()
                                            .countNotifi!
                                        : context
                                            .read<AddHabitCubit>()
                                            .countNotifi!);
                              },
                              child: const Icon(
                                Icons.add,
                              )))
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
