// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/models/contact_model.dart';

import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/repositories/contact_repository.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_pocketbase/utils/contact_json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsProvider = FutureProvider<ContactModel?>((ref) async {
  return await ref.read(contactRepositoryProvider).fetchContact();
});

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GetAppBar(),
        Expanded(flex: 1, child: Container(
          decoration: const BoxDecoration(
            color: bgColor
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(contactsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: const [
                  GetSearchBar(),
                  GetSectionIcons(),
                  GetContactLists()
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }
}

class GetAppBar extends ConsumerWidget {
  const GetAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        backgroundColor: greyColor,
        centerTitle: true,
        title: const Text("Contacts", style: TextStyle(
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w500
        )),
        leading: IconButton(
          onPressed: () {},
          icon: const Text("Sort",style: TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),),
        ),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.add, color: primary,))
        ],
      ),
    );
  }
}

class GetSearchBar extends ConsumerWidget {
  const GetSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      // height: 68,
      decoration: const BoxDecoration(
        color: greyColor
      ),
      child: Container(
        // height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: TextFormField(
          style: const TextStyle(
            color: white
          ),
          // textAlign: TextAlign.center,
          cursorColor: primary,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: white.withOpacity(0.3),),
            hintText: "Search",
            hintStyle: TextStyle(
              color: white.withOpacity(0.3),
              fontSize: 17
            )
          ),
        ),
      ),
    );
  }
}

class GetSectionIcons extends ConsumerWidget {
  const GetSectionIcons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List icons = [
      {
        "icon": Icons.location_on,
        "label": "Find People"
      },
      {
        "icon": Icons.person_add_alt_1_sharp,
        "label": "Invite Friends"
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        children: List.generate(icons.length, (index) {
          return Column(
            children: [
              Row(
                children: [
                  Icon(icons[index]['icon'], color: primary, size: 28,),
                  const SizedBox(width: 20,),
                  Text(icons[index]['label'], style: const TextStyle(
                    fontSize: 16, color: primary, fontWeight: FontWeight.w500
                  ),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Divider(
                  thickness: 1,
                  color: white.withOpacity(0.15),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class GetContactLists extends ConsumerWidget {
  const GetContactLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentContact = ref.watch(contactsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: currentContact.when(
        data: (data) {
          if (data != null && data.users.isNotEmpty) {
            return Column(
              children: List.generate(data.users.length, (index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(data.users[index].image),
                        ),
                        const SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.users[index].name, style: const TextStyle(
                              fontSize: 17, color: white, fontWeight: FontWeight.w500
                            ),),
                            const SizedBox(height: 2,),
                            const Text("Online", style: TextStyle(
                              fontSize: 13, color: primary, fontWeight: FontWeight.w500
                            ),)
                            // Text(data.users[index]['is_online'] ? "Online" : data?.users[index]['seen'], style: TextStyle(
                            //   fontSize: 13, color: data?.users[index]['is_online'] ? primary : white.withOpacity(0.5), fontWeight: FontWeight.w500
                            // ),)
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Divider(
                        thickness: 1,
                        color: white.withOpacity(0.15),
                      ),
                    )
                  ],
                );
              }),
            );
          }
          else {
            return Container(
              child: const Text("No chat", style: TextStyle(color: white),),
            );
          }
        },
        error: (_,__) => const Text('Error 😭'),
        loading: () => const Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        )
      ),
    );
  }
}

