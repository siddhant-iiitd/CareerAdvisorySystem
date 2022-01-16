/*
    IIS COURSE LAB ASSIGNMENT 1
    SIDDHANT AGARWAL ROLL NO - 2020247

    Instruction to run - 
    load the assignment1 program and use the predicate run(). to run then follow the options in the program.
    This program is based heavily on dynamically asserted facts. So, it is important to always completely exit the prolog termainal shell and reload when running the program again because the dyanamic facts stay in memory and interfare with the execution.
*/

/* 
    Rules
    This section contains all the predicates used in the program.
    In implementation of these, various prolog feautures such as lists, Input/Output, Recursion, Assert & Retract and comparison operators have been used effectively.
*/

checkCourses([]).
checkCourses([Head | Tail]) :- coursesTaken(List), isCourse(Head, List), checkCourses(Tail).

isCourse(X, [X | T]).
isCourse(X, [_ | T]) :- isCourse(X, T).

occupation(Name, army) :- field(yes), user_physical(Name, yes), assert(job(army)).
occupation(Name, musician) :- field(yes), user_music(Name, yes), assert(job(musician)).
occupation(Name, school_teacher) :- field(yes), user_children(Name, yes), assert(job(school_teacher)).
occupation(Name, video_and_photo_editor) :- field(yes), user_editing(Name, yes), assert(job(video_and_photo_editor)).

occupation(Name, software_engineer) :- field(no), checkCourses([cse1, cse2]), gpa(G), G >= 8, assert(job(software_engineer)).
occupation(Name, machine_learning_engineer) :- field(no), checkCourses([cse1, ai1, ai2]), gpa(G), G >= 8, assert(job(machine_learning_engineer)).
occupation(Name, full_stack_developer) :- field(no), checkCourses([cse1, cse2, cse3, ai1]), gpa(G), G >= 7, assert(job(full_stack_developer)).

occupation(Name, freelance_web_developer) :- field(no), flexible(Name, yes), checkCourses([cse1, cse3]), assert(job(freelance_web_developer)).
occupation(Name, freelance_game_developer) :- field(no), flexible(Name, yes), checkCourses([cse1, cse4]), assert(job(freelance_game_developer)).
occupation(Name, computer_science_tutor) :- field(no), flexible(Name, yes), checkCourses([cse1]), assert(job(computer_science_tutor)).

occupation(Name, electronics_engineer) :- field(no), checkCourses([ece1, ece2, ece3, ece4]), gpa(G), G >= 7, assert(job(electronics_engineer)).

addJobs(Name) :- occupation(Name, X), fail.
addJobs(_) :- listOfJobs(List), write(List).
listOfJobs([X | Tail]) :- retract(job(X)), listOfJobs(Tail).
listOfJobs([]).


/* 
    Interface 
    This section contains the predicates that are used to form the user interface and which handles the input/output of the options selected by the user.
*/

run() :- write("Hi there! What's your name \n"), read(Name), write("Hello, "), write(Name), write(", Welcome to the job suggestor software designed specially for engineering graduates!"), nl, interested(Name).

degree(btech, Name) :- write("Select your Courses: \n 1. Data Structures and Algorithms (cse1) \t 2. Digital Circuits (ece1) \n 3. Operating Systems (cse2) \t 4. Circuit Theory (ece2) \n 5. Signals and Systems (ece3) \t 6. Communication Systems (ece4) \n 7. Machine Learning (ai1)\t 8. Deep Learning (ai2) \n 9. Web Development (cse3) \t 10. Game development (cse4)"), nl, write("Enter course code (s to stop): "), assert(coursesTaken([])), enterCourse(Name).

interested(Name) :- write("Degrees aren't everything. It is a decision we made when we were a teenager in a different phase of life. Are you interested in making a career in the degree you have chosen or would you want to switch fields? (Enter yes to change fields and no to continue): "), read(Choice), assert(field(Choice)), fieldChoice(Name, Choice).

fieldChoice(Name, yes) :- write("Let's get to know you a little better!"), nl, write("Do you like to play instruments or like to sing? (yes or no) "), read(X), assert(user_music(Name, X)), write("Do you like interacting with children? (yes or no) "), read(Y), assert(user_children(Name, Y)), write("Are you physically fit and perform your best at ever-changing and difficult terrains? (yes or no) "), read(Z), assert(user_physical(Name, Z)), write("Do you interested in photo and video editing? (yes or no) "), read(A), assert(user_editing(Name, A)), nl, listJobs(Name).

fieldChoice(Name, no) :- degree(btech, Name).

time(Name) :- write("Would you like a well-paying corporate job (enter opt1) or one with flexible working hours (enter opt2) ? "), read(X), chosenTime(Name, X).

chosenTime(Name, opt1) :- assert(flexible(Name, no)), listJobs(Name).
chosenTime(Name, opt2) :- assert(flexible(Name, yes)), write("Good for you! A person who has the independence of working their own hours is truly independent."), nl, listJobs(Name).

listJobs(Name):- write(Name), write(", before we move onto job suggestions, just one small thing. The person you are today is not the person you must be tomorrow. The work we suggest today is exactly it, a suggestion! So never be afraid to follow what you want to do, when YOU want to do it!"), nl, write("If you do not get any recommendations, don't be upset. Just work harder to find your passion!."), nl, write("Here are the job recommendations that we feel will suit you: "), nl, addJobs(Name).


enterCourse(Name) :- write("Enter Course Code: "), read(C), addCourses(Name, C).
addCourses(Name, s) :- write("What is your current GPA? "), read(G), assert(gpa(G)), time(Name).
addCourses(Name, C) :- retract(coursesTaken(ListOfCourses)), assert(coursesTaken([C | ListOfCourses])), enterCourse(Name).
