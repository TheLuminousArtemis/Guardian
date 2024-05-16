import 'package:flutter/material.dart';
import 'package:guardian_traffic/screens/add_post_screen.dart';
import 'package:guardian_traffic/screens/feed_screen.dart';
import 'package:guardian_traffic/screens/profile_screen.dart';
import 'package:guardian_traffic/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
