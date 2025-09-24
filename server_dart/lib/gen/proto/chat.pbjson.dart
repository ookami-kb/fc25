// This is a generated file - do not edit.
//
// Generated from proto/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color', '3': 3, '4': 1, '5': 9, '10': 'color'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBWNvbG9yGAMgAS'
    'gJUgVjb2xvcg==');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'user_color', '3': 4, '4': 1, '5': 9, '10': 'userColor'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgASgJUgJpZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQSGwoJdX'
    'Nlcl9uYW1lGAMgASgJUgh1c2VyTmFtZRIdCgp1c2VyX2NvbG9yGAQgASgJUgl1c2VyQ29sb3IS'
    'GAoHY29udGVudBgFIAEoCVIHY29udGVudBIcCgl0aW1lc3RhbXAYBiABKANSCXRpbWVzdGFtcA'
    '==');

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert
    .base64Decode('Cg9SZWdpc3RlclJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = {
  '1': 'RegisterResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.fluttercon25.chat.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEhQKBXRva2VuGAEgASgJUgV0b2tlbhIrCgR1c2VyGAIgASgLMh'
    'cuZmx1dHRlcmNvbjI1LmNoYXQuVXNlclIEdXNlcg==');

@$core.Deprecated('Use sendMessageRequestDescriptor instead')
const SendMessageRequest$json = {
  '1': 'SendMessageRequest',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `SendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageRequestDescriptor =
    $convert.base64Decode(
        'ChJTZW5kTWVzc2FnZVJlcXVlc3QSGAoHY29udGVudBgBIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use sendMessageResponseDescriptor instead')
const SendMessageResponse$json = {
  '1': 'SendMessageResponse',
  '2': [
    {
      '1': 'message',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fluttercon25.chat.Message',
      '10': 'message'
    },
  ],
};

/// Descriptor for `SendMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageResponseDescriptor = $convert.base64Decode(
    'ChNTZW5kTWVzc2FnZVJlc3BvbnNlEjQKB21lc3NhZ2UYASABKAsyGi5mbHV0dGVyY29uMjUuY2'
    'hhdC5NZXNzYWdlUgdtZXNzYWdl');

@$core.Deprecated('Use watchMessagesRequestDescriptor instead')
const WatchMessagesRequest$json = {
  '1': 'WatchMessagesRequest',
};

/// Descriptor for `WatchMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchMessagesRequestDescriptor =
    $convert.base64Decode('ChRXYXRjaE1lc3NhZ2VzUmVxdWVzdA==');

@$core.Deprecated('Use watchMessagesResponseDescriptor instead')
const WatchMessagesResponse$json = {
  '1': 'WatchMessagesResponse',
  '2': [
    {
      '1': 'message',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fluttercon25.chat.Message',
      '10': 'message'
    },
  ],
};

/// Descriptor for `WatchMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchMessagesResponseDescriptor = $convert.base64Decode(
    'ChVXYXRjaE1lc3NhZ2VzUmVzcG9uc2USNAoHbWVzc2FnZRgBIAEoCzIaLmZsdXR0ZXJjb24yNS'
    '5jaGF0Lk1lc3NhZ2VSB21lc3NhZ2U=');
