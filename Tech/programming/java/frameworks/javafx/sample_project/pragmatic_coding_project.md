## Repo:
https://github.com/PragmaticCoding/AbsoluteBeginnersFX/tree/master

https://www.pragmaticcoding.ca/beginners/part1


### 1.  Single Responsibility Principle and Using Bindings
https://www.pragmaticcoding.ca/beginners/part3

**Application State**

The first thing you’ll notice is that we’ve added two StringProperty's fields to the class. Together these two Properties are going to act as our **State** for the application. One of them, the `name` will hold whatever the user types into the TextField and the other will hold the `greeting` that will display in the output Label.

Putting these two Properties into the class allows **all of the other coupling to be removed** .


### 2. MVC framework based design
https://www.pragmaticcoding.ca/beginners/part5


In the application dreferenced, various design patterns and classes are used to separate concerns and organize code effectively. Here’s an explanation of each class and how it fits into the overall architecture:

1. Model-View-Controller (MVC) Pattern

The application follows the Model-View-Controller (MVC) pattern, which separates the application logic into three components:

a. Model:

Role: The Model represents the application’s data and the business logic associated with that data. It is responsible for accessing and managing data (e.g., interacting with databases, performing calculations, or storing state).  

Example: In this project, the Model could be the classes that manage the user data or application state, such as an Invoice, User, or Customer class. These classes define the structure of the data and the business rules.

b. View:

`Role`: The View is responsible for the presentation layer of the application. It is the user interface that displays the data (from the Model) to the user and sends user interactions (such as button clicks) to the Controller.

`Example`: In this JavaFX application, the View is often constructed using JavaFX components (VBox, Button, TextField, etc.). The layout and presentation are built in methods such as createContents().

c. Controller:

Role: The Controller acts as the intermediary between the Model and View. It handles user input, processes it (often by calling the Model), and updates the View as necessary.

Example: The Controller listens for user actions (such as button presses) and reacts by updating the Model or the View. In JavaFX, event handling in controllers is often done using lambda expressions or event handler methods.

2. Interactor

Role: The Interactor is part of a clean architecture approach (often used in conjunction with MVC), where the business logic is kept in a separate layer. It is responsible for performing specific operations that may involve complex logic and is independent of the user interface.

Example: The Interactor could perform tasks such as processing user input, validating data, or interacting with external services. It interacts with the Model and acts on the data but does not directly deal with UI concerns.

3. Data Access Object (DAO)

Role: The DAO pattern is used to abstract the interaction with the data source (e.g., a database, file, or remote service). The DAO provides methods to create, read, update, and delete (CRUD) data from the database or data storage system, isolating the rest of the application from the details of how data is stored.

Example: In this project, you might have a CustomerDAO or InvoiceDAO that handles database operations like fetching customer records, saving invoices, or updating entries in the database.

4. Broker

Role: The Broker class serves as a middle layer between different subsystems in the application. It manages the communication between components or modules that may not directly interact with each other.

Example: In this application, a Broker might handle communication between the DAO layer and the business logic. It could coordinate actions such as retrieving data from multiple DAOs or performing more complex operations across multiple services.

Summary of Their Roles:

Model: Holds the application’s data and business logic.  
View: Displays data and collects user input.  
Controller: Handles user interactions, manipulates the Model, and updates the View.  
Interactor: Manages application-specific business logic and processes input independently from UI and storage concerns.  
DAO: Provides an interface for interacting with the database or other persistence layers, abstracting data access.  
Broker: Facilitates communication between subsystems, acting as an intermediary between different layers (e.g., DAO and business logic).  

This separation of concerns makes the application more modular, testable, and maintainable. Each component is responsible for a specific part of the functionality, which simplifies debugging, development, and future enhancements ￼ ￼.
