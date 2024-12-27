import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ChatHUb/colors.dart';
import 'package:ChatHUb/features/chat/controller/chat_controller.dart';
import 'package:ChatHUb/features/common/widget/utilis/loader.dart';
import 'package:ChatHUb/features/select_contacts/controller/select_contact_contorller.dart';
import 'package:ChatHUb/screens/errorscreen.dart';

class Selectcontactlist extends ConsumerStatefulWidget {
  static String id = "select_contact_screen";

  @override
  ConsumerState<Selectcontactlist> createState() => _SelectcontactlistState();
}

class _SelectcontactlistState extends ConsumerState<Selectcontactlist> {
  TextEditingController _searchController = TextEditingController();
  List<Contact> filteredContacts = [];
  List<Contact> allContacts = [];

  void selectcontact(WidgetRef ref, Contact selectedcontact, BuildContext context) {
    ref.read(selectcontactprovider).selectcontactcontoller(context, selectedcontact);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = allContacts
          .where((contact) => contact.displayName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search contacts...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ref.watch(contactprovider).when(
            data: (contactlists) {
              allContacts = contactlists;
              filteredContacts = filteredContacts.isEmpty && _searchController.text.isEmpty
                  ? allContacts
                  : filteredContacts;

              return ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => selectcontact(ref, filteredContacts[index], context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          // You can add an image or initials here
                        ),
                        title: Text(filteredContacts[index].displayName),
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              Navigator.pushNamed(context, ErrorScreen.id);
              return null;
            },
            loading: () => const loader(),
          ),
    );
  }
}
