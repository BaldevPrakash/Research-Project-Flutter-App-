import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color_utils.dart';

class NormalTextWithLetterSpacing extends StatelessWidget {
  const NormalTextWithLetterSpacing(
      {Key? key,
      required this.text,
      this.textColor = kPrimaryBlack,
      this.textSize = 16,
      this.textFontWeight = FontWeight.w400,
      this.maxLine = 2,
      this.textAlign = TextAlign.start,
      this.letterSpacingValue = 1})
      : super(key: key);

  final String text;
  final Color textColor;
  final double textSize;
  final FontWeight? textFontWeight;
  final int maxLine;
  final TextAlign? textAlign;
  final double letterSpacingValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: textColor,
        fontSize: textSize,
        fontWeight: textFontWeight,
        letterSpacing: letterSpacingValue,
      ),
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}
