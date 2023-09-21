import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    this.img,
    required this.title,
    required this.description,
    this.body,
  }) : super(key: key);

  final String? img, title, description;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: img == null
                ? const SizedBox()
                : SvgPicture.asset(
                    img!,
                    height: 250,
                  ),
          ),
        ),
        Text(
          title!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          description!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Colors.black45,
              ),
        ),
        Expanded(
          child: Center(
            child: body ?? const SizedBox(),
          ),
        ),
      ],
    );
  }
}
