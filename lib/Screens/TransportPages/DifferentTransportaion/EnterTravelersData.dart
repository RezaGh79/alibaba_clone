import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/finalTicketDataToBuy.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../../../Strings.dart';
import '../../../constants.dart';

class EnterTravelersData extends StatefulWidget {
  const EnterTravelersData({Key? key, required this.travelersCount}) : super(key: key);
  final int travelersCount;

  @override
  State<EnterTravelersData> createState() => _EnterTravelersDataState();
}

class _EnterTravelersDataState extends State<EnterTravelersData> {
  final List<String> items = ['مرد', 'زن'];
  String? selectedValue;

  List<TextEditingController> textControllerList = [];

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
          title: Text("مشخصات مسافرین"),
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
                            Text("کد ملی مسافران را وارد نمایید",
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                          Text("مشخصات سرپرست", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Icon(Icons.people)
                        ]),
                      ),
                      textFormFieldGenerator('نام', TextInputType.text),
                      textFormFieldGenerator('نام خانوادگی', TextInputType.text),
                      textFormFieldGenerator('شماره موبایل', TextInputType.number),
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
                  child: Text("تایید مشخصات")),
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
          controller: textControllerList[index - 1],
          keyboardType: TextInputType.number,
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
                child: Text(
                  'جنسیت',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  textFormFieldGenerator(String hint, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          // controller: textControllerList[index - 1],
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => FinalTicketToBuy()));
  }
}
