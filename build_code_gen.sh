#!/bin/bash

flutter pub run build_runner build --delete-conflicting-outputs

flutter pub run easy_localization:generate --source-dir ./assets/lang

flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir ./assets/lang