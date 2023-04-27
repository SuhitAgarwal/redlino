import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_touch_spin/reactive_touch_spin.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/validation_msgs.dart';
import '../../shared/profile_pic.dart';
import '../../theme/globals.dart';
import 'edit_profile_viewmodel.dart';

class EditProfileView extends StatelessWidget {
  // final bool isCelebrity;
  const EditProfileView({
    Key? key,
    // required this.isCelebrity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(),
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, _) {
        List<Widget> _renderCelebrityFields() {
          return [
            Text('Celebrity', style: textTheme.headline6),
            const SizedBox(height: 24),
            SizedBox(
              height: 100,
              child: ReactiveTextField(
                formControlName: 'bio',
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                style: blackTextStyle,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                ),
              ),
            ),
            const SizedBox(height: 8),
            ReactiveDateTimePicker(
              formControlName: 'meetAndGreetStart',
              type: ReactiveDatePickerFieldType.dateTime,
              style: blackTextStyle,
              valueAccessor: DateTimeValueAccessor(
                dateTimeFormat: DateFormat.yMMMd().add_jm(),
              ),
              decoration: const InputDecoration(
                labelText: 'Meet and Greet Start',
              ),
            ),
            const SizedBox(height: 8),
            ReactiveTouchSpin(
              formControlName: 'calls',
              max: 99,
              min: 0,
              textStyle: blackTextStyle,
              displayFormat: NumberFormat.compact(),
              decoration: const InputDecoration(
                labelText: 'Calls',
              ),
              validationMessages: (_) => {
                ValidationMessage.max: FieldValidationMessages.max(99),
                ValidationMessage.min: FieldValidationMessages.min(0),
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Socials',
              style: textTheme.headline6,
            ),
            const SizedBox(height: 24),
            ReactiveTextField(
              formControlName: 'tiktok',
              style: blackTextStyle,
              decoration: InputDecoration(
                labelText: 'TikTok',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/tiktok-logo.svg',
                    height: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ReactiveTextField(
              formControlName: 'instagram',
              style: blackTextStyle,
              decoration: InputDecoration(
                labelText: 'Instagram',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/instagram-logo.svg',
                    height: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ReactiveTextField(
              formControlName: 'snapchat',
              style: blackTextStyle,
              decoration: InputDecoration(
                labelText: 'Snapchat',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/snapchat-logo.svg',
                    height: 32,
                  ),
                ),
              ),
            ),
          ];
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFC5D0EC),
            title: const Text('Edit Profile', style: blackTextStyle),
            actions: [
              IconButton(
                onPressed: model.saveProfileInformation,
                tooltip: 'Save profile',
                icon: const Icon(Icons.check),
                splashRadius: 24,
              ),
            ],
            foregroundColor: Colors.black,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 1.0),
              child: Visibility(
                child: const LinearProgressIndicator(),
                visible: model.isBusy,
              ),
            ),
            elevation: 0,
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFC5D0EC),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.75, 1.00],
              ),
            ),
            child: ReactiveForm(
              formGroup: model.form,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 36,
                ),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        ProfilePic(
                          url: model.appUser.photoURL,
                          size: 54,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          height: 36,
                          width: 36,
                          child: Material(
                            color: Colors.white,
                            shape: maxBorderRadiusShape,
                            child: IconButton(
                              onPressed: model.newProfilePicture,
                              tooltip: 'Edit profile picture',
                              splashRadius: 18,
                              icon: const Icon(Icons.edit_outlined),
                              iconSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  ReactiveTextField(
                    formControlName: 'name',
                    style: blackTextStyle,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 36),
                  if (model.isCelebrity) ...[
                    ..._renderCelebrityFields(),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
