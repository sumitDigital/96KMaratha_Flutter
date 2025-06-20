import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class InVoiceScreen extends StatelessWidget {
  const InVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wraps the entire content to make it vertically scrollable
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  width: 150,
                  child: Image.asset("assets/applogo.png"),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Tax Invoice",
                    style: CustomTextStyle.boldHeading,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("A Unit of : ", style: CustomTextStyle.fieldName),
                const SizedBox(height: 10),
                const Text("Digital Marketing Studio Genex",
                    style: CustomTextStyle.bodytextbold),
                const SizedBox(height: 10),
                const Text(
                  "Digital Marketing StudioGenix LLP SkyScape Apt, Gangapur Rd, near KBT Circle, Saubhagya Nagar, Nashik, Maharashtra 422005",
                  style: CustomTextStyle.bodytextSmall,
                ),
                const SizedBox(height: 10),
                const Text("Buyer", style: CustomTextStyle.bodytextbold),
                RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Name : ", style: CustomTextStyle.bodytextSmall),
                  TextSpan(text: "Name", style: CustomTextStyle.bodytextSmall),
                ])),
                const SizedBox(height: 5),
                RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Address : ", style: CustomTextStyle.bodytextSmall),
                  TextSpan(
                      text: "Address", style: CustomTextStyle.bodytextSmall),
                ])),
                const SizedBox(height: 5),
                RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "State Name : ",
                      style: CustomTextStyle.bodytextSmall),
                  TextSpan(
                      text: "Maharashtra",
                      style: CustomTextStyle.bodytextSmall),
                ])),
                const SizedBox(height: 10),
                const Text("Invoice No. :",
                    style: CustomTextStyle.bodytextbold),
                const Text("JM/232/24-25",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                const Text("Payment Due On :",
                    style: CustomTextStyle.bodytextbold),
                const Text("27 Sep 2024",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                const Text("Payable Under Reverse Charge :  No",
                    style: CustomTextStyle.bodytextbold),

                // Data Table starts here
                const SizedBox(height: 20),
                const Text("Invoice Details",
                    style: CustomTextStyle.bodytextbold),
                const SizedBox(
                  height: 10,
                ),

                // Wrapping the DataTable in a horizontally scrollable SingleChildScrollView
                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Horizontal scrolling for the table
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey),
                    columns: const [
                      DataColumn(label: Text('Sr. ')),
                      DataColumn(label: Text('Particulars')),
                      DataColumn(label: Text('SAC')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('JM Marriage')),
                        DataCell(Text('99785')),
                        DataCell(Text('₹500')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('₹300')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('₹150')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Total Amount')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('₹1500')),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Amount Chargable",
                    style: CustomTextStyle.bodytextbold),
                Divider(
                  color: AppTheme.dividerColor,
                ),
                const Text(
                  "Declaration",
                  style: CustomTextStyle.fieldName,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "This is Declaration Info",
                  style: CustomTextStyle.bodytextSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Company's Bank Details ",
                  style: CustomTextStyle.bodytextbold,
                ),
                const SizedBox(
                  height: 10,
                ),

                RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(text: "Bank Name", style: CustomTextStyle.fieldName),
                  TextSpan(text: ""),
                ])),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(text: "A/C No . ", style: CustomTextStyle.fieldName),
                  TextSpan(text: ""),
                ])),
                const SizedBox(
                  height: 5,
                ),

                RichText(
                    text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Branch & IFC Code ",
                      style: CustomTextStyle.fieldName),
                  TextSpan(text: ""),
                ])),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: AppTheme.dividerColor,
                ),
                const Center(
                  child: Text(
                    "For Digital Marketing StudioGenex",
                    style: CustomTextStyle.bodytextbold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                const Text(
                  "Authorised Signatory",
                  style: CustomTextStyle.bodytext,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Subject to Nashik Juridication",
                    style: CustomTextStyle.bodytextbold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                const Center(
                  child: Text(
                    "This is Computer Generated Invoice",
                    style: CustomTextStyle.bodytext,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
