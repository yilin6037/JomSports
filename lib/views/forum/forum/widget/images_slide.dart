import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImagesSlide extends StatelessWidget {
  const ImagesSlide({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index, realIndex) => ClipRect(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                    image: NetworkImage(imageUrls[index]),
                    fit: BoxFit.fitHeight,
                    child: const InkWell()),
              ),
            ),
        options: CarouselOptions(
          aspectRatio: 1/1,
          enableInfiniteScroll: false,
        ));
  }
}
