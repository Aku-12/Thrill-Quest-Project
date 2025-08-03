class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);

  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:5050";

  static const String baseUrl = "$serverAddress/api";

  static const String imageUrl = "$serverAddress/uploads";

  static const String profileUrl = "$serverAddress/";

  //Auth

  static const String register = "/auth/register";

  static const String login = "/auth/login";

  static const String activities = "/admin/activities";

  static const getAllGuides = '/admin/guides';
  static const String review = '/api/review';

  static const String createBookings = "/admin/bookings/create";
  static const String updateBookings = "/update/bookings";
  static const String getMyBookings = "/admin/bookings/my-bookings";
  //profile
  static const String getUserProfile = "/profile/fetch";
  static const String changePassword = "/password/change";
  static String updateProfile(String userId) => "/profile/update/$userId";

  static const String getFavorites = "/profile/get-favorites";
  static const String addFavorite = "/profile/add-favorite";
  static const String removeFavorite = "/profile/remove-favorite";
}
