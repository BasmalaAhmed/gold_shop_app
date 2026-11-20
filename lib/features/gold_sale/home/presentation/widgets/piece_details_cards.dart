import 'package:flutter/material.dart';

class PieceDetailsCards extends StatelessWidget {
  const PieceDetailsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PieceDetailsCard(title: 'قائم', value: '4,500 مجم'),
        SizedBox(width: 6),
        PieceDetailsCard(title: 'فصوص', value: '300 مجم'),
        SizedBox(width: 6),
        PieceDetailsCard(title: 'صافي', value: '4,200 مجم'),
        SizedBox(width: 6),
        PieceDetailsCard(title: 'عيار', value: '21'),
      ],
    );
  }
}

class PieceDetailsCard extends StatelessWidget {
  const PieceDetailsCard({super.key, required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0XFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0XFF6B7280),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0XFF1A1D21),
            ),
          ),
        ],
      ),
    );
  }
}
