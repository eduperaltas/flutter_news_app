import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/Core/utils/resource/globals.dart';
import 'package:flutter_news_app/Domain/Models/news/news_response.dart';
import 'package:flutter_news_app/Presentation/Widgets/custom_tag.dart';
import 'package:flutter_news_app/Presentation/Widgets/image_container.dart';
import 'package:flutter_news_app/Presentation/discover/discover_screen.dart';

class ArgsToArticleScreen {
  final Article article;
  final String category;
  ArgsToArticleScreen({required this.article, required this.category});
}

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final article =
        (ModalRoute.of(context)!.settings.arguments as ArgsToArticleScreen)
            .article;
    final category =
        (ModalRoute.of(context)!.settings.arguments as ArgsToArticleScreen)
            .category;
    return ImageContainer(
      width: double.infinity,
      imageUrl: article.urlToImage ?? "",
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            _NewsHeadline(
              article: article,
              category: category,
            ),
            _NewsBody(article: article)
          ],
        ),
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              TagWithAvatarContent(
                  img:
                      "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${article.url}&size=64",
                  name: article.source!.name ?? "Unknown"),
              TagWithAvatarContent(
                  icon: Icons.person_2_rounded,
                  name: article.author ?? "Unknown"),
            ],
          ),
          const SizedBox(height: 10),
          //Launch URL
          GestureDetector(
            onTap: () {
              goToUrl(article.url!);
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    'Read in ${article.source!.name ?? "Browser"}',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.open_in_browser_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            article.title!,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            article.content ?? "No content available",
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class TagWithAvatarContent extends StatelessWidget {
  const TagWithAvatarContent({
    super.key,
    this.img,
    required this.name,
    this.icon,
    this.imgSize,
    this.textSize,
    this.backColor,
  });

  final String? img;
  final IconData? icon;
  final String name;
  final Color? backColor;
  final double? imgSize, textSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CustomTag(
        backgroundColor: backColor ??
            (icon == null ? Colors.black : Colors.grey.withAlpha(150)),
        children: [
          img != null
              ? CircleAvatar(
                  radius: 10,
                  child: CachedNetworkImage(
                    height: imgSize ?? 50,
                    width: imgSize ?? 50,
                    imageUrl: img!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                )
              : icon != null
                  ? Icon(
                      icon,
                      color: Colors.white,
                    )
                  : const SizedBox(),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                    fontSize: textSize ??
                        Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsHeadline extends StatelessWidget {
  const _NewsHeadline({
    Key? key,
    required this.article,
    required this.category,
  }) : super(key: key);

  final Article article;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          category.isNotEmpty
              ? CustomTag(
                  backgroundColor: Colors.grey.withAlpha(150),
                  children: [
                    Text(
                      category,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          Text(
            article.title!,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            '${dateToString(article.publishedAt!)} ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
