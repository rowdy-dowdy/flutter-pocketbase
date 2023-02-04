import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_pocketbase/utils/contact_json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          child: SingleChildScrollView(
            child: Column(
              children: const [
                GetSearchBar(),
                GetSectionIcons(),
                GetContactLists()
              ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: List.generate(10, (index) {
          return Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(contact_data[index]["img"]),
                  ),
                  const SizedBox(width: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact_data[index]['name'], style: const TextStyle(
                        fontSize: 17, color: white, fontWeight: FontWeight.w500
                      ),),
                      const SizedBox(height: 2,),
                      Text(contact_data[index]['is_online'] ? "Online" : contact_data[index]['seen'], style: TextStyle(
                        fontSize: 13, color: contact_data[index]['is_online'] ? primary : white.withOpacity(0.5), fontWeight: FontWeight.w500
                      ),)
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
      ),
    );
  }
}

