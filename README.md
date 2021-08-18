# pwa_update_listener

A Flutter package for checking if there is a new PWA version, and it is ready to be update.

<img width="645" alt="Screen Shot 2021-08-18 at 22 15 28" src="https://user-images.githubusercontent.com/18391546/129917712-0f2300e4-955f-4077-b0e7-42f41a52b741.png">

## Getting Started
Wrap `PwaUpdateListener` around a widget in the main page. `onReady` will be called when the child widget is shown (eg. when a page is pop and the main page is shown) or when the app return from background.

```dart
Scaffold(
      body: PwaUpdateListener(
        onReady: () {
          /// Show a snackbar to get users to reload into a newer version
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Expanded(child: Text('A new update is ready')),
                  TextButton(
                    onPressed: () {
                      reloadPwa();
                    },
                    child: Text('UPDATE'),
                  ),
                ],
              ),
              duration: Duration(days: 365),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
```
