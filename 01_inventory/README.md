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
And we will store the state of the system in a flat file.

To test the system we are going to use rspec.
