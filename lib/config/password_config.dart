class PasswordConfig {
  // الثابت الأولي المضاف للحساب (الأساس)
  static const int seedOffset = 43;

  // العدد الأولي للتدوير اليومي (القفزة بين محاولة وأخرى)
  static const int rotationPrime = 1373;

  // عدد مرات التدوير المسموحة في اليوم الواحد (دورات 0, 1, 2, 3, 4)
  static const int dailyCycles = 5;
}