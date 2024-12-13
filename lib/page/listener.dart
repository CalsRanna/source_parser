import 'dart:math';

import 'package:blurhash_ffi/blurhash_the_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/schema/book.dart';

class ListenerPage extends ConsumerStatefulWidget {
  const ListenerPage({super.key, required this.book});

  final Book book;

  @override
  ConsumerState<ListenerPage> createState() => _ListenerPageState();
}

class _ListenerPageState extends ConsumerState<ListenerPage> {
  // FlutterTts tts = FlutterTts();
  bool speaking = false;
  List<_TtsVoiceConfig> voiceConfigs = [];

  @override
  void dispose() {
    // tts.stop();
    super.dispose();
  }

  void fetchChapters() async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    await notifier.refreshCatalogue();
  }

  void initVoices() async {
    // List<dynamic> voices = await tts.getVoices;
    // setState(() {
    //   voiceConfigs = voices
    //       .map((voice) => _TtsVoiceConfig.fromJson(voice))
    //       .where((config) => config.locale.startsWith('zh'))
    //       .toList();
    // });
    // tts.setVoice(voiceConfigs.first.toJson());
  }

  @override
  void initState() {
    super.initState();
    fetchChapters();
    initVoices();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      precacheImage(NetworkImage(widget.book.cover), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(bookNotifierProvider);
    final index = book.index;
    var title = '';
    if (book.chapters.isNotEmpty) {
      title = book.chapters[index].name;
    }
    return Stack(
      children: [
        Image(
          image: BlurhashTheImage(NetworkImage(widget.book.cover)),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(title),
                  const Spacer(),
                  _AnimatedBookCover(cover: widget.book.cover),
                  const Spacer(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.timer_outlined),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.speed_outlined),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.comment_outlined),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.no_crash_outlined),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.more_horiz),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),
                  // Row(
                  //   children: [
                  //     IconButton(
                  //       icon: const Icon(Icons.replay_30_outlined),
                  //       onPressed: () {},
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(2),
                  //           color:
                  //               Theme.of(context).colorScheme.primaryContainer,
                  //         ),
                  //         height: 2,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     IconButton(
                  //       icon: const Icon(Icons.forward_30_outlined),
                  //       onPressed: () {},
                  //     )
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.library_add_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous_outlined),
                      ),
                      Consumer(builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () => toggleVoice(ref),
                          icon: Icon(
                            speaking
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 96,
                          ),
                        );
                      }),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.list_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _VoiceConfigSelector(voiceConfigs: voiceConfigs),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void toggleVoice(WidgetRef ref) async {
    setState(() {
      speaking = !speaking;
    });
    if (speaking) {
      // final notifier = ref.read(bookNotifierProvider.notifier);
      // final content = await notifier.getContent(widget.book.index);
      // tts.speak(content);
    } else {
      // tts.pause();
    }
  }
}

class _AnimatedBookCover extends StatefulWidget {
  const _AnimatedBookCover({
    required this.cover,
  });

  final String cover;

  @override
  State<_AnimatedBookCover> createState() => _AnimatedBookCoverState();
}

class _AnimatedBookCoverState extends State<_AnimatedBookCover>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    controller.duration = const Duration(seconds: 10);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Tween(begin: 0.0, end: 1.0).animate(controller),
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * pi * 2,
          child: ClipOval(
            child: Image.network(
              widget.cover,
              fit: BoxFit.fitWidth,
              height: 240,
              width: 240,
            ),
          ),
        );
      },
    );
  }
}

class _VoiceConfigSelector extends StatelessWidget {
  const _VoiceConfigSelector({
    required this.voiceConfigs,
  });

  final List<_TtsVoiceConfig> voiceConfigs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryContainer = colorScheme.primaryContainer;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => select(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: primaryContainer.withValues(alpha: 0.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('朗读音色·${voiceConfigs.firstOrNull?.name ?? ''}'),
            const Icon(Icons.refresh_outlined),
          ],
        ),
      ),
    );
  }

  void select(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(voiceConfigs[index].name),
          );
        },
        itemCount: voiceConfigs.length,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}

class _TtsVoiceConfig {
  String locale = '';
  String name = '';

  _TtsVoiceConfig.fromJson(dynamic json) {
    locale = json['locale'];
    name = json['name'];
  }

  Map<String, String> toJson() {
    return {'locale': locale, 'name': name};
  }
}
