/*
Authors: Joel and Mitch
Date: 3/10/19
Group: Mijdas(kw01)
Purpose:
*/

import 'package:flutter/material.dart';

import '../Models/Criterion.dart';
import '../Models/Student.dart';

import '../Pages/AnnouncementsPage.dart';
import '../Pages/SettingsPage.dart';
import '../Pages/ProfilePage.dart';
import '../Pages/HomePage.dart';
import '../Pages/StudentsPage.dart';
import '../Pages/AssessmentPage.dart';
import '../Pages/CriteriaPage.dart';

Route announcementRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AnnouncementsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route settingsRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );

}

Route profileRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route homeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomePage(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route studentsRoute(String id) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => StudentsPage(context, id),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
       //assigning page ID
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route assessmentRoute(String s) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AssessmentPage(context,s),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route criteriaRoute(Student s, String assID, List<Criterion> criteria) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CriteriaPageState(s,assID,criteria),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}