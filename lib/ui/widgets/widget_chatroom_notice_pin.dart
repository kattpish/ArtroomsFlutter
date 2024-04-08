
import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/utils/utils_screen.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class WidgetChatroomNoticePin extends StatefulWidget {

  final DataNotice dataNotice;
  final bool isExpandNotice;
  final void Function() onToggle;
  final void Function() onHide;

  const WidgetChatroomNoticePin(this.dataNotice, this.isExpandNotice, {super.key,
    required this.onToggle,
    required this.onHide,
  });

  @override
  State<WidgetChatroomNoticePin> createState() {
    return _WidgetChatroomNoticePinState();
  }

}

class _WidgetChatroomNoticePinState extends State<WidgetChatroomNoticePin> {

  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpandNotice;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.isExpandNotice ? 150 : 36,
      duration: const Duration(milliseconds: 500),
      onEnd: () {
        setState(() {
          isExpanded = widget.isExpandNotice;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        constraints: BoxConstraints(minHeight: widget.isExpandNotice ? 50 : 36),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            widget.onToggle();
            setState(() {
              if(isExpanded) {
                isExpanded = false;
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: isTablet(context) ? 22 : 20,
                          height: isTablet(context) ? 22 : 20,
                          padding: const EdgeInsets.only(
                            top: 2.55,
                            left: 1.64,
                            right: 1.77,
                            bottom: 2.46,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 16.5,
                                height: 15,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/icons/icon_notice.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(minHeight: isExpanded ? 80 : 20),
                                  alignment: widget.isExpandNotice ? Alignment.topLeft : Alignment.topLeft,
                                  child: Text(
                                    widget.dataNotice.notice,
                                    style: TextStyle(
                                      color: const Color(0xFF3A3A3A),
                                      fontSize: isExpanded ? (isTablet(context) ? 17 : 15) : (isTablet(context) ? 15 : 14),
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                      letterSpacing: -0.28,
                                    ),
                                    maxLines: widget.isExpandNotice ? 5 : 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Visibility(
                                  visible: isExpanded,
                                  child: Container(
                                    width: double.infinity,
                                    height: 32,
                                    margin: const EdgeInsets.only(top: 10.0),
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        minimumSize:
                                        const Size(double.infinity, 48),
                                        foregroundColor: colorPrimaryBlue,
                                        backgroundColor: colorMainGrey200,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: const Text(
                                        '다시 열지 않음',
                                        style: TextStyle(
                                          color: colorMainGrey900,
                                          fontSize: 13,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.26,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: () {
                                        widget.onHide();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: isTablet(context) ? 22 : 20,
                          height: isTablet(context) ? 22 : 20,
                          margin: const EdgeInsets.only(right: 2.0),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(widget.isExpandNotice
                                    ? "assets/images/icons/icon_arrow_up.png"
                                    : "assets/images/icons/icon_arrow_down.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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