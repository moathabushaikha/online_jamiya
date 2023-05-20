import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.jamiya, required this.currentUser, required int tab})
      : super(key: key);
  final Jamiya jamiya;
  final User currentUser;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ApiMongoDb apiMongoDb = ApiMongoDb();
  List? dates, payments;
  bool paid = false;
  int listLength = 0;

  @override
  void initState() {
    getMyPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (dates != null) {
      if (dates!.isNotEmpty) {
        listLength = dates!.length;
      }
    }
    return Scaffold(
          appBar: AppBar(title: Text('Payment Schedule for ${widget.jamiya.name}')),
          body: listLength == 0
              ? Center(
                  child: dates == null ? const Text('لا يوجد دفعات') :Column(
                    children: const [
                      Text('getting data'),
                      CircularProgressIndicator(
                        color: Colors.black,
                      )
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.6,
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: ListView.builder(
                            primary: true,
                            itemCount: listLength + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Payments',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                              index--;
                              return Container(
                                  height: 50,
                                  color:
                                      index.isEven ? Colors.blueAccent : Colors.blueAccent.shade100,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(DateFormat('dd/MM/yyyy').format(dates?[index])),
                                          const Spacer(),
                                          StatefulBuilder(builder: (context, setState) {
                                            return ElevatedButton(
                                              onPressed: payments![index] == false
                                                  ? () async {
                                                      Map<String, dynamic>? paymentResult =
                                                          await apiMongoDb.initiatePayment(
                                                              widget.jamiya,
                                                              widget.currentUser,
                                                              index);
                                                      if (paymentResult == null) {
                                                        showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) =>
                                                              AlertDialog(
                                                            title: const Text('Wrong Payment'),
                                                            content: const Text(
                                                                'You have missed a payment, pay previous month first'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(context, 'OK'),
                                                                child: const Text('OK'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        getMyPayments();
                                                      }
                                                    }
                                                  : null,
                                              child: const Text('pay'),
                                            );
                                          }),
                                          const Spacer(),
                                          payments?[index] == false
                                              ? const Text('not paid')
                                              : const Text('paid'),
                                        ],
                                      )));
                            }),
                      )),
                ));
  }

  void getMyPayments() async {
    Map<String, dynamic>? payment =
        await apiMongoDb.getUserPayments(widget.currentUser, widget.jamiya);
    setState(() {
      payments = payment?['userPayment']['isPaid'];
      dates = payment?['userPayment']['paymentDates'];
    });
  }
}
