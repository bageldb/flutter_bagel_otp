# BagelDB Flutter - OTP Authentication

A Flutter based OTP Authentication component, used to verify your mobile number with OTP (One Time Password) using BagelAuth Authentication.


## Table of contents
- [Features](#features)
- [Getting started](#getting-started)
- [Usage](#usage)
- [Methods](#methods)
- [BagelAuth project setup steps](#bagelauth-project-setup-steps)
- [Want to Contribute?](#want-to-contribute)
- [Need Help / Support?](#need-help)
- [Collection of Components](#collection-of-Components)
- [Changelog](#changelog)
- [License](#license)
- [Keywords](#Keywords)

------

## Features

* Select country with flag & country code.
* Verify mobile number with OTP all over the world.


## Getting started

* Download this sample project and import widget dart files in your Flutter App.
* Update Widgets UI based on your requirements.


## Usage

Setup process is described below to integrate in sample project.

### Methods

###### Configure Country Picker Widget & implement method for call back selected country details e.g
```javascript
    // Put CountryPicker Widget
    CountryPicker(
        callBackFunction: _callBackFunction
    );

    // Create callback function
    void _callBackFunction(String name, String dialCode, String flag) {
        // place your code
    }
```


###### Configure PINEntryTextField For OTP (One Time Password)
```javascript

    // add this package in pubspec.yaml file
    pin_entry_text_field: ^0.1.4

    // run this command to install package
    flutter pub get

    // add PINEntryTextField in class
    PinEntryTextField(
      fields: 6,
      onSubmit: (text) {
      },
    )
```

###### Verify otp
```javascript
    //Method for verify otp entered by user
    Future<void> verifyOtp(String phone) async {
    if (smsOTP == null || smsOTP == '') {
      showAlertDialog(context, 'please enter 6 digit otp');
      return;
    }
    try {
      // final res = await db.bagelUsersRequest.updatePassword(phone, smsOTP); // via sdk

			// via internal api (currently using an express js server)
      final res = await dio.post(
        '/updateUserPassword',
        data: {
          'emailOrPhone': phone,
          'password': smsOTP,
        },
      );
      print({res});

      final validateOtpRes = await db.bagelUsersRequest.validateOtp(smsOTP);
      print({validateOtpRes});
      Navigator.pushReplacementNamed(context, '/homeScreen');
    } catch (e) {
      print({e});
    }
  }
```

###### Handle errors
```javascript
    //Method for handle the errors
    void handleError(PlatformException error) {
      switch (error.code) {
        case 'ERROR_INVALID_VERIFICATION_CODE':
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            errorMessage = 'Invalid Code';
          });
          showAlertDialog(context, 'Invalid Code');
          break;
        default:
          showAlertDialog(context, error.message);
          break;
      }
    }
```

------

### BagelAuth project setup steps

1. add: bagel token to lib/.environment.dart
```javascript
final bagelToken =
    "YOUR BAGEL TOKEN";
```
2. add: bagel token to server/.env
```javascript
PORT=3000
BAGEL_TOK="YOUR BAGEL TOKEN"
```

3. install dependencies
```javascript
cd server
npm install
```

4. run dev script (runs nodemon and flutter for web)
```javascript
npm run dev
```
------

## Want to Contribute?

- Added some functionality, created something awesome, made this code better, added better documentation, etc.
- [Fork it](http://help.github.com/forking/).
- Create new branch to contribute your changes.
- Commit all your changes to your branch.
- Submit a [pull request](http://help.github.com/pull-requests/).

------

<!-- ## Changelog
Detailed changes for each release are documented in [CHANGELOG](./CHANGELOG). -->

## License
[MIT](LICENSE)

## Keywords
Flutter-OTP-Authentication, BagelAuth-OTP, BagelAuth, Authentication, OTP-Authentication
