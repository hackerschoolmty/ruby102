# Inventory

We are going to build an application that will help the user to keep
track of the number of items in inventory.

The user will be able to...

* See a list with all the articles, showing the name, the uniq code and
  the number of items.
* Add an article, with the name, a uniq code and number of items. Here
  the system will validate the presence of name, code and quantity, and
  also that the code is uniq and the quantity is a positive number.
* Increment the number of items of an article
* Decrement the number of items of an article. Here the system will
  remove ensure that the quantity can't be less than 0.

## Tools

Here we are going to use **sinatra** to expose the system to the system.
And we will store the state of the system in a flat file (or maybe just
in memory).

To test the system we are going to use rspec.

## Instructor steps

There is a branch (with pull request) called `instructor_steps` that has
the complete application developed by the instructor step by step.

This branch will be used by the instructor to follow a logic path
through the class.

This branch can also be used by the student to use it as a reference,
but the student should really try to build this app alone.

I think is better not merge this branch into master.
