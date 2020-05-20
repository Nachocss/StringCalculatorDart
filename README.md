# String Calculator Kata for Flutter
The following is a TDD + BLoC Kata.

This classic kata guides you step by step through the implementation of a calculator that receives a *String* as input. It is a good exercise on refactoring and incremental implementation. It is also a good candidate for practising TDD.

# First step
Create a function *add* that takes a *String* and returns a *String*:

> *String add(String number)*
- The method can take 0, 1 or 2 numbers separated by comma, and returns their sum.
- An empty string will return “0”.
- Example of inputs: *"", "1", "1.1,2.2".*

# Many numbers
Allow the *add* method to handle an unknow number of arguments.

# Newline as separator
Allow the *add* method to handle newlines as separators:

- *"1\n2,3"* should return *"6"*.
- *"175.2,\n35"* is invalid and should return the message *"Number expected but '\n' found at position 6."*

# Missing number in last position
Don’t allow the input to end in a separator.

- *"1,3,"* is invalid and should return the message *Number expected but EOF found.*

# Custom separators
Allow the *add* method to handle a different delimiter. To change the delimiter, the beginning of the input will contain a separate line that looks like this:

> //[delimiter]\n[numbers]
- *"//;\n1;2"* should return *"3"*
- *"//|\n1|2|3"* should return *"6"*
- *"//sep\n2sep3"* should return *"5"*
- *"//|\n1|2,3"* is invalid and should return the message *"'|' expected but ',' found at position 3."*

All existing scenarios should work as before.

# Negative numbers
Calling *add* with negative numbers will return the message *"Negative not allowed : " listing all negative numbers that were in the list of numbers.*

- *"-1,2"* is invalid and should return the message *"Negative not allowed : -1"*
- *"2,-4,-5"* is invalid and should return the message *"Negative not allowed : -4, -5"*

# Multiple errors
Calling *add* with multiple errors will return all error messages separated by newlines.

- *"-1,,2"* is invalid and return the message *"Negative not allowed : -1\nNumber expected but ',' found at position 3."*

# Errors management
Introduce an internal *add* function returning a number instead of a *String*, and test many solutions for the error messages. - Exception - *maybe* and monad approch - POSIX return code with message managemement - tuple with error struct like in Go - etc.

# Other operations
Write a function for multiply with same rules


# 
# From this point, the goal is to practice the BLoC pattern
# 

# Get user input by GUI
Create a Widget that contains an input text field.
This Widget will add an Event to the Stream when pressing ENTER.

# Process the new Event
When our new event is created, call the function *add* and get the result and print it through console.

# Print the result in the GUI
Create a new Widget that will print the result of the function *add*.

# Inform through a text field if anything went wrong
Tell the user what happened in case an error was found.

# Create a Dialog that informs about the errors instead of loading another State like we did before
First, build a basic Dialog that just contains text.
Then, add an *Accept* button to be able to close it.

# Allow the user to navigate between the different States
Add a *BACK* button that takes you from the final State to the Initial State

# Add an operator selector
In the input State, let the user to choose the operation to be performed.

# Support navigation using back arrow instead of the button we just created
In order to do this, you should check *WillPopScope* widget and its parameter *onWillPop*.

# Display a notification if an operation button is pressed but the input is empty
A good way to achieve this is by implementing a SnackBar.