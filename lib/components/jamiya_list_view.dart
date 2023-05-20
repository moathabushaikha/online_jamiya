import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/components/participants_list_view.dart';
import 'package:provider/provider.dart';
import '../managers/managers.dart';
import '../models/models.dart';

class JamiyasListView extends StatefulWidget {
  final List<Jamiya>? jamiyas;

  const JamiyasListView({Key? key, this.jamiyas}) : super(key: key);

  @override
  State<JamiyasListView> createState() => _JamiyasListViewState();
}

class _JamiyasListViewState extends State<JamiyasListView> {
  ApiMongoDb apiMongoDb = ApiMongoDb();
  AppCache appCache = AppCache();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () =>
              context.goNamed('jamiya', params: {'tab': '1', 'selectedJamiyaId': '${index + 1}'}),
          child: ExploreJamiyaThumbnail(jamiya: widget.jamiyas?[index],currentUser: currentUser),
        );
      },
      padding: const EdgeInsets.all(8),
      itemCount: widget.jamiyas?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 5,
      ),
    );
  }
  void getCurrentUser() async {
    currentUser = await appCache.getCurrentUser();
    setState(() {
      Provider.of<JamiyaManager>(context, listen: false).getJamiyat();
    });
  }

  formattedDate(DateTime date) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    String formattedStartingDate = dateFormat.format(date);
    return formattedStartingDate;
  }
}
