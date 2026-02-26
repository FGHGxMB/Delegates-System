class PasswordConfig {
  static const int seedOffset = 43;
  static const int rotationPrime = 1373;

  // تم التعديل إلى 10 دورات في اليوم
  static const int dailyCycles = 10;

  // كلمة سر الطوارئ الثابتة (لا تتغير أبداً)
  static const String masterPassword = 'FGHGx';
}