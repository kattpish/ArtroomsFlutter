
import 'package:artrooms/beans/bean_notice.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class buildNoticePin extends StatefulWidget {

  final DataNotice dataNotice;
  bool isExpandNotice;
  final void Function() onToggle;
  final void Function() onHide;

  buildNoticePin(this.dataNotice, this.isExpandNotice, {super.key,
    required this.onToggle,
    required this.onHide,
  });

  @override
  State<buildNoticePin> createState() {
    return _buildNoticePin();
  }

}

class _buildNoticePin extends State<buildNoticePin> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isExpandNotice ? null : 36,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
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
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        width: 20,
                        height: 20,
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
                                alignment: widget.isExpandNotice
                                    ? Alignment.topLeft
                                    : Alignment.topLeft,
                                child: Text(
                                  widget.dataNotice.notice,
                                  style: const TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 14,
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
                                visible: widget.isExpandNotice,
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
                        width: 20,
                        height: 20,
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
    );
  }

}