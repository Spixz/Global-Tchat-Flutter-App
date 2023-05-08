<h1 align="center">
    GlobalTchat
</h1>

<p align="center">
    <b>
        <a href="https://global-tchat-flutter-app.web.app">Web demo</a><br>
    </b>
</p>



<p align="center">
  <img src="https://user-images.githubusercontent.com/43412722/236698740-1ac462e9-2ae2-4766-9d7d-2eac0fa5e0a2.png" alt="second screen group"/>
  <img src="https://user-images.githubusercontent.com/43412722/236699189-a59d4bb9-a52a-4b33-839b-d66de73c4e2a.png" alt="first screen group"/>
</p>

Messaging app (web/android) based on Whatsapp style using firebase and based on an implementation of the **[Riverpod Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)** from **[Andrea Bizzotto](https://github.com/bizz84/)**.

# Features

- [x]  Realtime Messaging
- [x]  Group conversations
- [x]  Send pictures
- [x]  “Was read” indicator

# Architecture

<img width="2453" alt="Architecture-transparant" src="https://user-images.githubusercontent.com/43412722/236888379-a8327b92-2ad2-4f6d-90ba-8b94db480395.png">

## Presentation Layer

It contain at least a view, a state and a controller.

The view represents the page itself. The logic of this view is managed by a Controller. This controller contains an immutable state (a class that contains variables). The view can read the state but can only modify it via the controller. Each time the state is modified, the widget is rebuilt.

Put the links of create_conversation (view, controller, state).

## Domain Layer

Contains the defitions of the entities / objects used by the views, controllers. These objects are immutable in order to be able to propagate state changes in our application. The modification of a state is done by copy.

## Model Layer

Communicates with external APIs (REST API, Local Storage API, ...) and converts the received data into models from the layer domain.
