class SliderModel {
  String imageAssetPath;
  String title;
  String description;

  SliderModel(
      {required this.imageAssetPath,
        required this.title,
        required this.description});
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding1.webp",
    title: "onboarding1_title",
    description: "onboarding1_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding2.webp",
    title: "onboarding2_title",
    description: "onboarding2_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding3.webp",
    title: "onboarding3_title",
    description: "onboarding3_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding4.webp",
    title: "onboarding4_title",
    description: "onboarding4_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding5.webp",
    title: "onboarding5_title",
    description: "onboarding5_desc",
  ));

  return slides;
}
