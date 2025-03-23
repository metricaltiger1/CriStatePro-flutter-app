import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? imageUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.imageUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  bool _isDownloading = false;
  bool _isVideoDownloaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfVideoDownloaded();
  }

  void _checkIfVideoDownloaded() async {
    final cacheManager = DefaultCacheManager();
    FileInfo? fileInfo = await cacheManager.getFileFromCache(widget.videoUrl);
    if (fileInfo != null) {
      _isVideoDownloaded = true;
      _initializeVideo(fileInfo);
    }
  }

  void _initializeVideo(FileInfo fileInfo) {
    _controller = VideoPlayerController.file(fileInfo.file)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      allowedScreenSleep: false,
      looping: true,
      allowFullScreen: true,
      showControls: true,
      placeholder: const Center(child: CircularProgressIndicator()),
    );
  }

  void _downloadVideo() async {
    setState(() {
      _isDownloading = true;
    });

    final cacheManager = DefaultCacheManager();
    FileInfo? fileInfo = await cacheManager.downloadFile(widget.videoUrl);
    _initializeVideo(fileInfo);

    setState(() {
      _isDownloading = false;
      _isVideoDownloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.imageUrl != null && !_isVideoDownloaded)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset(
                'assets/image_placeholder.png',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) {
                return const Center(child: Text('Image not available'));
              },
            ),
          ),
        VisibilityDetector(
          key: Key(widget.videoUrl),
          onVisibilityChanged: (visibilityInfo) {
            if (!_isVideoInitialized) return;
            if (visibilityInfo.visibleFraction == 0) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
          child: _isVideoInitialized
              ? Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                )
              : _buildDownloadButton(),
        ),
        if (!_isVideoDownloaded) _buildDownloadButton(),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Center(
      child: _isDownloading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/progressbar.json',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 10),
                const Text('Downloading...'),
              ],
            )
          : GestureDetector(
              onTap: _downloadVideo,
              child: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/download.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_isVideoInitialized) {
      _controller.dispose();
      _chewieController.dispose();
    }
  }
}
