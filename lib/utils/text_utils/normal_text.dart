import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color_utils.dart';

class NormalText extends StatelessWidget {
  const NormalText(
      {Key? key,
      required this.text,
      this.textColor = kPrimaryBlack,
      this.textSize = 16,
      this.textFontWeight = FontWeight.w400,
      this.maxLine = 2,
      this.textAlign = TextAlign.start,
      this.fontStyle = FontStyle.normal,
      this.isEnglish = true})
      : super(key: key);

  final String text;
  final Color textColor;
  final double textSize;
  final FontWeight? textFontWeight;
  final int maxLine;
  final TextAlign? textAlign;
  final FontStyle fontStyle;
  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: isEnglish
            ? GoogleFonts.inter(
                color: textColor,
                fontSize: textSize,
                fontWeight: textFontWeight,
                fontStyle: fontStyle)
            : GoogleFonts.cairo(
                color: textColor,
                fontSize: textSize,
                fontWeight: textFontWeight,
                fontStyle: fontStyle),
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        textDirection: TextDirection.ltr);
  }
}
