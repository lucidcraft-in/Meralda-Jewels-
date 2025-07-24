import 'dart:math';

int generateRandomNumber() {
  Random random = Random();
  return random.nextInt(9000) +
      1000; // Generates a random number between 1000 and 9999
}
