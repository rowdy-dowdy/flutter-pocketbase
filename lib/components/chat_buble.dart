// import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBubbleChat2 extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final bool isLast;

  const CustomBubbleChat2(
      {Key? key,required this.isMe,required this.message,required this.time,required this.isLast})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isMe) {
      if (!isLast) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message,
                          style: TextStyle(fontSize: 16, color: white),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          time,
                          style: TextStyle(
                              fontSize: 12, color: white.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                  padding:
                    const EdgeInsets.only(left: 20, right: 14, bottom: 10),
                ),
            )
          ],
        );
      }
    } else {
      if (!isLast) {
        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: TextStyle(fontSize: 16, color: white),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          time,
                          style: TextStyle(
                              fontSize: 12, color: white.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 14, bottom: 10),
              ),
            )
          ],
        );
      }
    }
  }
}

class CustomBubbleChat extends ConsumerWidget {
  final String message;
  final bool isMe;
  final String time;
  final bool isLast;
  const CustomBubbleChat({required this.message, required this.time, required this.isLast, this.isMe = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = isMe ? primary : greyColor;
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: color
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(message, style: const TextStyle(color: white ),),
                      const SizedBox(height: 3,),
                      Text(time,style: TextStyle(fontSize: 12, color: white.withOpacity(0.4))),
                    ],
                  ),
                ),
                isLast ? Positioned(
                  left: !isMe ? 0 : null,
                  right: isMe ? 0 : null,
                  bottom: 0,
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: ChatBubbleTriangle(color: color, isMe: isMe),
                    ),
                  )
                ) : const SizedBox()
              ],
            ),
          ),
        ),
      ]
    );
  }
}

class ChatBubbleTriangle extends CustomPainter {
  final Color color;
  final bool isMe;

  ChatBubbleTriangle({required this.color, this.isMe = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;

    var path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(size.height, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, 0);
    }
    else {
      path.moveTo(0, size.height);
      path.lineTo(size.height, 0);
      path.lineTo(size.height, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

