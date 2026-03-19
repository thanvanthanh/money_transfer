// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QRCodeSection extends StatelessWidget {
  final String qrUrl;
  final String? description;

  const QRCodeSection({
    super.key,
    required this.qrUrl,
    this.description = 'Quét mã QR bằng app ngân hàng bất kỳ',
  });

  void _downloadImage() {
    final anchor = html.AnchorElement(href: qrUrl)
      ..setAttribute('download', 'qr-code.png')
      ..target = '_blank';
    anchor.click();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
          ),
          padding: const EdgeInsets.all(15),
          child: CachedNetworkImage(
            imageUrl: qrUrl,
            width: 300,
            height: 300,
            placeholder: (context, url) => Container(
              width: 300,
              height: 300,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 300,
              height: 300,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description ?? 'Quét mã QR bằng app ngân hàng bất kỳ',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _downloadImage,
          icon: const Icon(Icons.download),
          label: const Text('Tải ảnh QR'),
        ),
      ],
    );
  }
}
