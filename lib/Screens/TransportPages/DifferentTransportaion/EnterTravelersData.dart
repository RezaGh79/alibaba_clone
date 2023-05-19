import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/finalTicketDataToBuy.dart';
import 'package:alibaba_clone/models/TicketsModel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Strings.dart';
import '../../../constants.dart';

class EnterTravelersData extends StatefulWidget {
  const EnterTravelersData(
      {Key? key,
      required this.travelersCount,
      required this.ticket,
      required this.boughtSeats,
      required this.dateJalali,
      required this.prefs})
      : super(key: key);

  final int travelersCount;
  final TicketModel ticket;
  final List<int> boughtSeats;
  final Jalali dateJalali;
  final SharedPreferences prefs;

  @override
  State<EnterTravelersData> createState() => _EnterTravelersDataState();
}

class _EnterTravelersDataState extends State<EnterTravelersData> {
  final List<String> items = ['مرد', 'زن'];
  String? selectedValue;

  List<TextEditingController> textControllerList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    for (var i = 0; i < widget.travelersCount; i++) {
      textControllerList.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("مشخصات مسافرین",
              style: const TextStyle(
                fontFamily: 'font',
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Column(children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.travelersCount + 1, (index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
                            Text(
                              "کد ملی مسافران را وارد نمایید",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.people)
                          ]),
                        );
                      } else {
                        return nationalNumberTextField(index);
                      }
                    }),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
                          Text("مشخصات سرپرست",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16)),
                          SizedBox(width: 10),
                          Icon(Icons.people)
                        ]),
                      ),
                      textFormFieldGenerator('نام', TextInputType.text, nameController),
                      textFormFieldGenerator(
                          'نام خانوادگی', TextInputType.text, lastNameController),
                      textFormFieldGenerator(
                          'شماره موبایل', TextInputType.number, numberController),
                      SizedBox(height: 5),
                      genderDropDown(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    submitUserData();
                  },
                  child: Text("تایید مشخصات",
                      style: const TextStyle(
                        fontFamily: 'font',
                      ))),
              SizedBox(height: 10)
            ]),
          ),
        ));
  }

  Widget nationalNumberTextField(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          style: TextStyle(
            fontFamily: 'font',
          ),
          controller: textControllerList[index - 1],
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                )),
            hintText: Strings.nationalNumber,
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
          ),
        ),
      ),
    );
  }

  genderDropDown() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: const [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'جنسیت',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'font'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'font'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            // width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              // border: Border.all(
              //   // color: Colors.black26,
              // ),
              color: kPrimaryColor,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.white,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            padding: null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            elevation: 8,
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  textFormFieldGenerator(
      String hint, TextInputType inputType, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          style: TextStyle(fontFamily: 'font'),
          controller: textEditingController,
          keyboardType: inputType,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                )),
            hintText: hint,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
          ),
        ),
      ),
    );
  }

  void submitUserData() {
    List<String> nationalCodes = [];
    for (var controller in textControllerList) {
      nationalCodes.add(controller.text);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FinalTicketToBuy(
                  ticket: widget.ticket,
                  nationalCodes: nationalCodes,
                  superVisorName: nameController.text,
                  superVisorLastName: lastNameController.text,
                  superVisorMobile: numberController.text,
                  menOrWomen: selectedValue.toString(),
                  boughtSeats: widget.boughtSeats,
                  dateJalali: widget.dateJalali,
                  prefs: widget.prefs,
                )));
  }
}
