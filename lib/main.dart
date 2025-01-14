import 'package:flutter/material.dart';

import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactListPage(),
    );
  }
}

class ContactInfo {
  const ContactInfo({
    required this.avatarAsset,
    required this.name,
    required this.email,
    required this.phone,
  });

  final String avatarAsset;
  final String name;
  final String email;
  final String phone;
}

const contactInfos = [
  ContactInfo(
    avatarAsset: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    name: 'Tom Arbo',
    email: 'tom.arbo@example.com',
    phone: '(711) 265-9193',
  ),
  ContactInfo(
    avatarAsset: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    name: 'Elly Foster',
    email: 'elly@example.com',
    phone: '(675) 844-7400',
  ),
  ContactInfo(
    avatarAsset: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    name: 'Carolyn Durnham',
    email: 'carolyn.durnham@example.com',
    phone: '(995) 565-4039',
  ),
  ContactInfo(
    avatarAsset: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    name: 'Corrina Nicholls',
    email: 'c.nicholls@example.com',
    phone: '(966) 291-5045',
  ),
  ContactInfo(
    avatarAsset: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    name: 'Omer Anderson',
    email: 'omer@example.net',
    phone: '(519) 978-4733',
  ),
];

class ContactListPage extends StatelessWidget {

  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => ContactListItem(contactInfo: contactInfos[i]),
        itemCount: contactInfos.length,
      ),
    );
  }
}

class ContactListItem extends StatefulWidget {

  const ContactListItem({
    super.key,
    required this.contactInfo,
  });

  final ContactInfo contactInfo;

  @override
  State<ContactListItem> createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> {
  final _avatarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        key: _avatarKey,
        width: 50,
        height: 50,
        child: AvatarHero(contactInfo: widget.contactInfo),
      ),
      title: Text(widget.contactInfo.name),
      subtitle: Text(widget.contactInfo.email),
      onTap: () {
        Navigator.push(
          context,
          CircularClipRoute<void>(
            builder: (context) => ContactDetailPage(contactInfo: widget.contactInfo),
            expandFrom: _avatarKey.currentContext!,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn.flipped,
            opacity: ConstantTween(1),
            transitionDuration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}

class AvatarHero extends StatelessWidget {
  final ContactInfo contactInfo;

  const AvatarHero({
    super.key,
    required this.contactInfo,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          contactInfo.avatarAsset,
          fit: BoxFit.cover,
        ),
      ),
    );

    return Hero(
      tag: 'image_${contactInfo.hashCode}',
      createRectTween: (begin, end) {
        return RectTween(
          begin: Rect.fromCenter(
            center: begin!.center,
            width: begin.width,
            height: begin.height,
          ),
          end: Rect.fromCenter(
            center: end!.center,
            width: end.width,
            height: end.height,
          ),
        );
      },
      child: child,
    );
  }
}

class ContactDetailPage extends StatefulWidget {

  const ContactDetailPage({
    super.key,
    required this.contactInfo,
  });

  final ContactInfo contactInfo;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactInfo.name),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 140,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 220,
                    width: 220,
                    padding: const EdgeInsets.all(20.0),
                    child: AvatarHero(contactInfo: widget.contactInfo),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(flex: 1),
                1: FlexColumnWidth(99),
              },
              textBaseline: TextBaseline.alphabetic,
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              children: [
                _buildTableRow(label: 'Email', value: widget.contactInfo.email),
                _buildTableRow(label: 'Phone', value: widget.contactInfo.phone),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow({required String label, required String value}) {
    return TableRow(
      children: [
        IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        Text(value),
      ],
    );
  }
}