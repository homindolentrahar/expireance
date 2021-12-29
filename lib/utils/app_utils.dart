abstract class AppUtils {
  static String createSlug(String value) {
    return value.trim().split(" ").map((str) => str.toLowerCase()).join("-");
  }
}
