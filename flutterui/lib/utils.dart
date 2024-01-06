import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'prefs.dart' as prefs;

Future<http.Response?> makeRequest(String url, String method,
    {Map<String, String>? headers, Object? body, bool useAuthHeader = false}) {
  var uri = Uri.parse(url);

  if (useAuthHeader) {
    headers ??= {};
    headers['Authorization'] = 'Bearer ${prefs.jwtAccessToken}';
  }

  switch (method) {
    case 'get':
      return http.get(uri, headers: headers);
    case 'post':
      return http.post(uri, headers: headers, body: body);
  }

  return Future(() => null);
}

Future<http.Response?> getRequest(String url,
    {Map<String, String>? headers, bool useAuthHeader = false}) {
  return makeRequest(url, 'get',
      headers: headers, useAuthHeader: useAuthHeader);
}

Future<dynamic> decodedGetBody(String url,
    {Map<String, String>? headers, bool useAuthHeader = false}) {
  return getRequest(url, headers: headers, useAuthHeader: useAuthHeader)
      .then((value) => json.decode(value!.body));
}

Future<dynamic> decodedGetResults(String url,
    {Map<String, String>? headers, bool useAuthHeader = false}) {
  return decodedGetBody(url, headers: headers, useAuthHeader: useAuthHeader)
      .then((value) => value['results']);
}

Future<http.Response?> postRequest(String url,
    {Map<String, String>? headers, Object? body, bool useAuthHeader = false}) {
  return makeRequest(url, 'post',
      headers: headers, body: body, useAuthHeader: useAuthHeader);
}

Future<dynamic> decodedPostBody(String url,
    {Map<String, String>? headers, Object? body, bool useAuthHeader = false}) {
  return postRequest(url,
          headers: headers, body: body, useAuthHeader: useAuthHeader)
      .then((value) => json.decode(value!.body));
}

Future<dynamic> decodedPostResults(String url,
    {Map<String, String>? headers, Object? body, bool useAuthHeader = false}) {
  return decodedPostBody(url,
          headers: headers, body: body, useAuthHeader: useAuthHeader)
      .then((value) => value['results']);
}
