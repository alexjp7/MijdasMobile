# mijdas_app


Brief & very rough file explanation:

- main.dart                 :: this is the heart, first page loaded from here and navigator to the 'home_manager.dart' page.
- home_manager.dart         :: this is basic 'home' page, the AppBar atm is used to go back or to go to next page, BottomAppBar used for testing functions.
    + home.dart                 :: planned to be used as object class for reference by the manager, might be refactored.
- assessment_manager.dart   :: basic 'assessment' list beginning structure, has been scrapped for accordion menu within 'home_manager.dart' page.
    + assessments.dart          :: same as home.dart, should probs be refactored later.
- criteria_manager.dart     :: empty template for Joel to paste in his current criteria page or change as he sees fit.
- signup_manager.dart       :: empty template page for creation of a signup form page.


Notes: 

- all .dart files are inside the 'lib' folder.
- main.dart atm has basic text field for testing back end rather than complete login form.
- lots of random commented out stuff for use later
- look at the random classes in main.dart to see how the navigator works, pagetwo is an example page, 
and pagethree shows how to use the popUntil to reach a previous point in the stack

TODO:

- Fill in barebones basic outline of each page
- populate pages from backend
- finish up overall look & feel