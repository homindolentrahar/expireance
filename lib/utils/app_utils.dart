abstract class AppUtils {
  static String createSlug(String value) {
    return value.split(" ").map((str) => str.toLowerCase()).join("-");
  }
}
