import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:developer';

class PusherConfig {
  static final PusherConfig _instance = PusherConfig._internal();
  factory PusherConfig() => _instance;
  PusherConfig._internal();

  late PusherChannelsFlutter _pusher;

  final String _apiKey = "b89bd6d5b89a7d27e9af";
  final String _cluster = "eu";

  PusherChannelsFlutter get instance => _pusher;

  Future<void> initPusher(Function(PusherEvent) onEvent,
      {String channelName = "public"}) async {
    _pusher = PusherChannelsFlutter.getInstance();
    try {
      _pusher.init(
        apiKey: _apiKey,
        cluster: _cluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );

      await _pusher.connect();
      log("Pusher connected.");

      await _pusher.subscribe(channelName: channelName);
      log("Subscribed to: $channelName");
    } catch (e) {
      log("Error in Pusher initialization: $e");
      await _pusher.disconnect();
    }
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }

  Future<void> reconnect(String channelName) async {
    try {
      await disconnect();
      await _pusher.subscribe(channelName: channelName);
      await _pusher.connect();
      log("Pusher reconnected to channel: $channelName");
    } catch (e) {
      log("Error during Pusher reconnection: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection state changed: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("Pusher error: $message (code: $code) exception: $e");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("Subscribed to $channelName with data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("Subscription error: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("Decryption failure for event $event: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("Member added to $channelName: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("Member removed from $channelName: $member");
  }
}
