# Tractors

![iOS](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Swift](https://img.shields.io/badge/Swift-4.2.1-blue.svg)
[![Build Status](https://app.bitrise.io/app/c9b154f65c94c24d/status.svg?token=PASbmhkjo85ZrkwfkI37IQ&branch=master)](https://app.bitrise.io/app/c9b154f65c94c24d)


- [Description](#description)
- [Structure](#structure)
- [Project](#project)
- [Schema](#schema)
- [Code](#code)
- [Catalog](#catalog)
- [Delegate](#delegate)
- [RequesterProtocol](#requesterprotocol)
- [Presenter](#presenter)
- [View](#view)
- [Application](#application)
- [Contributing](#contributing)
- [Requirements](#requirements)


# Description
Tractors displays the position of the tractors in the field in real time with markers over a map.

You can get the name of the driver by selecting any of the tractors markers.

Optionally you can also see your current position.


# Structure
## Project
The entry point for the project is the **Tractors Workspace**. It was decided since the beginning to start with a Xcode Workspace instead of just a Xcode Project so it can be extended as needed. In case for example we need to attach another project or if we want to add _CocoaPods_ to the project.


The workspace contains one Xcode Project named **Tractors**.


Tractors project contains 3 different targets:


- Tractors
- Tests
- Application


### Tractors
A **Static Library**.

The business layer and entities of the project is extracted and encapsulated in this target.

The rationale behind creating a different target for this layer is to improve testability and encapsulation. In order to truly create _Unit Tests_ the tested subjects should be separated from the Application layer (the UI).

The outcome of this is that whenever we need to run the automated tests it is not necessary to start the application, with the following advantages:

- Running the tests is sometimes up to 80% faster
- CI (Bitrise) also runs the tests faster
- Any action taken by the application when running is not executed when testing, for example asking for the user's permission to access their location.
- If at any point the project needs to install third party dependencies, let's say, through the use of _CocoaPods_, these doesn't have to be installed in order to run the tests.
- Tests are more reliable as they don't depend anymore on the application.


Additionally by encapsulating this layer in a separated target we are encouraged to create interfaces (protocols) and therefor public APIs for our own entities, enforcing the [Dependency Inversion Principle](https://martinfowler.com/articles/injection.html).


### Tests
A **Unit Testing Bundle**

For the moment we are focusing on Unit Testing, in the future we might come with adding some Integration and UI Testing, but these do not come as a priority. We are not against adding those other kind of testing, it is more important to us though that the Application layer (UI) and Integration layer are more flexible and easy to change.

We consider the business layer mission critical, therefor it should come along with a well defined and trusted set of tests, maintained constantly, and refactored whenever needed (refactor the tests). Whenever possible Test Driven Development (TDD) should be applied in the process.


We are not concern at all in _Test Coverage_ though, as we don't think this adds neither removes quality from a project.


### Application
An **iOS Application target**

The UI of the project.

The details of the project, everything that is volatile and that we should be able to change everyday, multiple times a day if necessary.

This section of the project is not meant to be Unit Tested. In the future we might consider adding some Integration Test or UI Tests, but they don't come as a priority.

Following the [Dependency Inversion Principle](https://martinfowler.com/articles/injection.html) this part of the project should depend on the business layer (import the business layer), and the business layer should not know anything about this layer, therefore allowing us to have as many UI as we want and as different among them as they need to be, all sharing the same business logic.


This layer of the project is divided in two sections:


- Presenter
- View


#### Presenter
The bridge between the business layer and the user facing layer, the UI.

Should know as much as necessary of the business layer so it can prepare the ViewModels but know nothing of how these ViewModels are going to be displayed to the user.

We consider ViewModel as a collection of elements with relation among them and enough information of how they should be displayed to the user. They should resemble data in the business layer but not necessarily be part of it.

The Presenter is in charge of notify the View whenever new information is ready to be displayed.


#### View
The user facing interface. The endpoint of the details of the application, therefore as volatile as it gets and should be as flexible to change as possible.

Should own the Presenter layer and depend on it.


We decided to entirely create the UI programatically, as we consider is more flexible than working directly with Interface Builders and Storyboards or Nib files.

We consider we can have more control of what is happening and of the lifecycle of our UI elements by doing it so.

At the same time we believe it improves code reviews when instead of looking at a XML file written by the Interface Builder you are looking at Swift code written by another human being.


## Schema
Project has two different schemas:


- Tractors
- Application


### Tractors
A schema pointing to the Tractors Static Library target.

This schema is meant to be used by the CI for testing the project. It can also be used by the developers if they want to test the project themselves locally but we encourage them to test instead using the Application target, both run the same tests.


### Application
A schema pointing to the iOS Application.

This schema is meant for developers contributing to the project, it is pointing to the Application target which itself imports the Tractors static library. At the same time this schema is ready to test the Tests target, so you can run the application or run the tests in here.


This schema is the one ready to launch the application (debug), either on a real device or on the simulator.


This schema is also ready to create an archive of the application, in case for example you need to deploy it.


# Code
## Catalog
The public facing API of the business layer.

From Catalog you can get the current tractors on the field.

You can also register a delegate to the catalog so it can get notified when new updates are available.


### Tractors
An array of the current tractors on the field.


### Interval
Modify the interval if you want to update the information of the tractors more or less constantly.


### Formatter
We need to format Zulu timestamps, and we decided against using the built in **ISO8601DateFormatter** because it is only supported on iOS 10+.

### Queue
A private serialised dispatch queue.

In order to avoid threading issues while iterating and modifying tractors array we need to make sure we are always doing it in the same thread and in sequential fashion. Otherwise this could lead to application crashes if for example the UI is accessing the array at the same time new information is being added to it.


## Delegate
We opted for the Delegate Pattern as a way of registering to updates for the protocol because is flexible enough yet simple to implement.
It can also be extended in the future if it is necessary.


## RequesterProtocol
All URL requests are being made on the business layer and we don't want to test this requests as we would be depending on external elements, like Internet connection and server/data stability. Instead we abstracted the request functionality into an interface, and we test that this interface is being used, the details of the implementation doesn't matter to us (the actual requests) as we have little power over them.


## Presenter
Imports the static library and prepares the ViewModel to be displayed on the UI. As ViewModel we are currently using `MKPointAnnotation`, which is a representation on the tractors of our business layer but it is ready to be displayed and understood by the UI.


Presenter acts as a Delegate of the Catalog.


## View
Register itself to updates made on the ViewModel by the Presenter and displays a map showing the current tractors on the field.


We opted for using Apple Maps as opposed to using Google maps for convenience, it is easier to implement them and we don't need any third party libraries, at the same time we don't need any credentials or authentication for them.


If deemed necessary we might be able to switch to Google maps in the future, the only layer needed to change in this case would be the View.


## Application
We avoid the use of storyboards and everything is constructed programatically. We consider the UI created through Interface Builder easier to make but harder to maintain and less flexible. As it is true that creating UI programatically takes more time it is also true that any change made and therefor is maintainability is faster.


# Contributing
## Requirements
- Xcode 10.1 or above.
- All code should be written on Swift 4.2.1 or above and avoid adding Objective-C code at all, for maintainability.
- We encourage the use of Extreme Programming practices and most importantly Test Driven Development.

