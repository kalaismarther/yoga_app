import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:yoga_app/features/Testimonials/models/testimonial_model.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class TestimonialItem extends StatefulWidget {
  const TestimonialItem({super.key, required this.testimonial});

  final TestimonialModel testimonial;

  @override
  State<TestimonialItem> createState() => _TestimonialItemState();
}

class _TestimonialItemState extends State<TestimonialItem> {
  late VideoPlayerController _controller;
  //
  @override
  void initState() {
    if (widget.testimonial.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.testimonial.videoUrl),
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          setState(() {});
        });
    }
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.outline, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: widget.testimonial.customerProfile,
                placeholder: (context, url) => Container(
                  clipBehavior: Clip.hardEdge,
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: LoadingShimmer(
                    height: double.infinity,
                    width: double.infinity,
                    baseColor: Theme.of(context).colorScheme.tertiary,
                    highlightColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const HorizontalSpace(width: 16),
              Text(widget.testimonial.customerName)
            ],
          ),
          const VerticalSpace(height: 4),
          Divider(
            thickness: 1.5,
            color: Theme.of(context).colorScheme.outline,
          ),
          const VerticalSpace(height: 4),
          if (widget.testimonial.description.isNotEmpty)
            ExpandableText(
              widget.testimonial.description,
              expandText: 'show more',
              collapseText: 'show less',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: mobile ? null : 20),
              linkColor: Colors.blue,
              maxLines: 3,
            ),
          const VerticalSpace(height: 10),
          if (widget.testimonial.videoUrl.isNotEmpty) ...[
            _controller.value.isInitialized
                ? Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Stack(
                          children: [
                            VideoPlayer(_controller),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: _controller.value.isPlaying
                                  ? const SizedBox()
                                  : const Icon(
                                      Icons.play_circle_filled,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: LoadingShimmer(
                        height: double.infinity,
                        width: double.infinity,
                        baseColor: Theme.of(context).colorScheme.tertiary,
                        highlightColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
          ]
        ],
      ),
    );
  }
}
