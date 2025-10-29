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

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding6.webp",
    title: "onboarding6_title",
    description: "onboarding6_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding7.webp",
    title: "onboarding7_title",
    description: "onboarding7_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding8.webp",
    title: "onboarding8_title",
    description: "onboarding8_desc",
  ));

  slides.add(SliderModel(
    imageAssetPath: "assets/images/onboarding9.webp",
    title: "onboarding9_title",
    description: "onboarding9_desc",
  ));

  return slides;
}
