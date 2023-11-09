import 'package:bullion/core/constants/display_type.dart';
import 'package:flutter/material.dart';

class DisplayMessage {
  String? title;
  String? message;
  String? subText;
  String? messageType;
  String? messageDisplayType;

  Color get color {
    switch (messageType) {
      case MessageType.error:
        return const Color(0xFFC30000);
      case MessageType.info:
        return Colors.blue;
      case MessageType.success:
        return const Color(0xff19A672);
      case MessageType.warning:
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Color get textColor {
    switch (messageType) {
      case MessageType.error:
        return const Color(0xFFC30000);
      default:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (messageType) {
      case MessageType.error:
        return Icons.highlight_remove_outlined;
      case MessageType.info:
        return Icons.info_outline;
      case MessageType.success:
        return Icons.check_circle_outline_outlined;
      case MessageType.warning:
        return Icons.warning_amber_outlined;
      default:
        return Icons.info_outline;
    }
  }

  DisplayMessage(
      {this.title,
      this.message,
      this.subText,
      this.messageType,
      this.messageDisplayType});

  DisplayMessage.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    subText = json['sub_text'];
    messageType = json['message_type'];
    messageDisplayType = json['message_display_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['sub_text'] = this.subText;
    data['message_type'] = this.messageType;
    data['message_display_type'] = this.messageDisplayType;
    return data;
  }
}
