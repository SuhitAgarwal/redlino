import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_data_service.dart';
import '../../shared/snackbar_service.dart';
import '../../theme/globals.dart';

class EditProfileViewModel extends BaseViewModel {
  final _authSv = sl<AuthService>();
  final _navSv = sl<NavigationService>();
  final _dataService = sl<UserDataService>();
  final _snackService = sl<SnackbarService>();
  final _storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  late FormGroup form;

  AppUser get appUser => _dataService.user!;
  User get user => _authSv.firebaseUser!;

  bool isCelebrity = false;

  EditProfileViewModel() {
    form = FormGroup({
      'name': FormControl<String>(
        value: appUser.name,
        validators: [Validators.required],
      ),
      'bio': FormControl<String>(),
      'meetAndGreetStart': FormControl<DateTime>(),
      'calls': FormControl<num>(
        value: 0,
        validators: [Validators.min(0), Validators.max(99)],
      ),
      'tiktok': FormControl<String>(
        value: appUser.socials?.tiktok,
      ),
      'instagram': FormControl<String>(
        value: appUser.socials?.instagram,
      ),
      'snapchat': FormControl<String>(
        value: appUser.socials?.snapchat,
      ),
    });
  }

  FormControl<String> get name => form.control('name') as FormControl<String>;
  FormControl<String> get bio => form.control('bio') as FormControl<String>;
  FormControl<num> get calls => form.control('calls') as FormControl<num>;
  FormControl<DateTime> get meetAndGreetStart =>
      form.control('meetAndGreetStart') as FormControl<DateTime>;
  FormControl<String> get tiktok =>
      form.control('tiktok') as FormControl<String>;
  FormControl<String> get instagram =>
      form.control('instagram') as FormControl<String>;
  FormControl<String> get snapchat =>
      form.control('snapchat') as FormControl<String>;

  void initializeModel() async {
    isCelebrity = await _authSv.isCelebrity;
    if (isCelebrity) {
      final celeb = appUser.celebrityInfo;
      bio.updateValue(celeb!.bio ?? "");
      calls.updateValue(celeb.calls);
      if (celeb.meetAndGreetStart != null) {
        meetAndGreetStart.updateValue(celeb.meetAndGreetStart);
      }
    }
    notifyListeners();
  }

  Future<void> newProfilePicture() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (picked == null) return;
    final cropped = await ImageCropper.cropImage(
      sourcePath: picked.path,
      iosUiSettings: const IOSUiSettings(
        title: 'Crop profile picture',
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
      ),
      maxWidth: 600,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop profile picture',
        statusBarColor: red,
      ),
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (cropped == null) return;
    final snap = await _storage.ref('pfps/${user.uid}').putFile(cropped);
    final url = await snap.ref.getDownloadURL();
    await user.updatePhotoURL(url);
    await _dataService.updatePhotoURL(url);
    notifyListeners();
  }

  void disableAllFields() {
    for (final f in form.controls.values) {
      f.markAsDisabled();
    }
  }

  Future<void> saveProfileInformation() async {
    if (!form.valid) {
      _snackService.showCustomSnackBar(
        message: 'Profile form is invalid!',
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
      return;
    }
    var userClone = appUser.copyWith(
      name: name.value!.trim(),
      socials: AppUserSocials(
        instagram: instagram.value?.trim(),
        snapchat: snapchat.value?.trim(),
        tiktok: tiktok.value?.trim(),
      ),
    );
    if (isCelebrity) {
      CelebrityInfo info;
      if (userClone.celebrityInfo == null) {
        info = CelebrityInfo(
          favorites: 0,
          calls: 0,
          limboCoins: 0,
        );
      } else {
        info = userClone.celebrityInfo!;
      }
      userClone = userClone.copyWith(
        celebrityInfo: info.copyWith(
          bio: (bio.value ?? "").trim(),
          meetAndGreetStart: meetAndGreetStart.value,
          calls: calls.value!.toInt(),
        ),
      );
    }
    disableAllFields();
    setBusy(true);
    await _dataService.updateUserData(userClone);
    setBusy(false);
    _navSv.back();
    _snackService.showCustomSnackBar(
      message: 'Profile information updated',
      variant: SnackbarType.success,
      duration: kSnackbarDuration,
    );
  }
}
