// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

/// Catches a [PlatformException] and returns an [Exception].
///
/// If the [Exception] is a [PlatformException], a [FirebaseException] is returned.
Never convertPlatformExceptionToFirebaseException(
  Object exception,
  StackTrace stackTrace, {
  required String plugin,
}) {
  if (exception is! Exception || exception is! PlatformException) {
    Error.throwWithStackTrace(exception, stackTrace);
  }

  Error.throwWithStackTrace(
    platformExceptionToFirebaseException(exception, plugin: plugin),
    stackTrace,
  );
}

/// Converts a [PlatformException] into a [FirebaseException].
///
/// A [PlatformException] can only be converted to a [FirebaseException] if the
/// `details` of the exception exist. Firebase returns specific codes and messages
/// which can be converted into user friendly exceptions.
FirebaseException platformExceptionToFirebaseException(
  PlatformException platformException, {
  required String plugin,
}) {
  Map<String, String>? details = platformException.details != null
      ? Map<String, String>.from(platformException.details)
      : null;

  String? code;
  String message = platformException.message ?? '';

  if (details != null) {
    code = details['code'] ?? code;
    message = details['message'] ?? message;
  }

  return FirebaseException(
    plugin: plugin,
    code: code,
    message: message,
  );
}
