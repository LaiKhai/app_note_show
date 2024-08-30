import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:Noteshow/view/pages/profile/profile/index.dart';

import '../../create_show_detail/index.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required ProfileBloc profileBloc,
    super.key,
  }) : _profileBloc = profileBloc;

  final ProfileBloc _profileBloc;

  @override
  ProfileScreenState createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenState();

  final qrData = TextEditingController();
  final displayData = TextEditingController();
  Dio dio = Dio();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> generateQRCode() async {
    final response = await http.post(
      Uri.parse("http://localhost:4500/api/create-qrcode"),
      body:
          jsonEncode({"qrData": qrData.text, "displayData": displayData.text}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      setState(() {
        _imageBytes = response.bodyBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        bloc: widget._profileBloc,
        builder: (
          BuildContext context,
          ProfileState currentState,
        ) {
          if (currentState is UnProfileState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorProfileState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: const Text('reload'),
                  ),
                ),
              ],
            ));
          }
          if (currentState is InProfileState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: qrData,
                    // focusNode: titleFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorName.black,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8))),
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: displayData,
                    // focusNode: titleFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                        labelText: 'Display',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorName.black,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8))),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await generateQRCode();
                      },
                      child: const Text("generate QR code"))
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._profileBloc.add(LoadProfileEvent());
  }
}
