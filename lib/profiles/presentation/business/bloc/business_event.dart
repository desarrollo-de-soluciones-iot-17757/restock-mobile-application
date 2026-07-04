import 'package:image_picker/image_picker.dart';

abstract class BusinessEvent {
  const BusinessEvent();
}

class BusinessStarted extends BusinessEvent {
  const BusinessStarted();
}

class BusinessRucChanged extends BusinessEvent {
  const BusinessRucChanged(this.ruc);

  final String ruc;
}

class BusinessCompanyNameChanged extends BusinessEvent {
  const BusinessCompanyNameChanged(this.companyName);

  final String companyName;
}

class BusinessMainLocationChanged extends BusinessEvent {
  const BusinessMainLocationChanged(this.mainLocation);

  final String mainLocation;
}

class BusinessImageChanged extends BusinessEvent {
  const BusinessImageChanged(this.image);

  final XFile? image;
}

class BusinessChangesDiscarded extends BusinessEvent {
  const BusinessChangesDiscarded();
}

class BusinessSubmitted extends BusinessEvent {
  const BusinessSubmitted();
}
