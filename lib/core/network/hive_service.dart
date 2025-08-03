import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thrill_quest/app/constant/hive/hive_table_constant.dart';
import 'package:thrill_quest/features/auth/data/model/user_hive_model.dart';
import 'package:thrill_quest/features/bookings/data/model/bookings_hive_model.dart';
import 'package:thrill_quest/features/guides/data/model/guide_hive_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}thrillquest.db';
    Hive.init(path);

    if (!Hive.isAdapterRegistered(BookingsHiveModelAdapter().typeId)) {
      Hive.registerAdapter(BookingsHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(GuideHiveModelAdapter().typeId)) {
      Hive.registerAdapter(GuideHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(UserHiveModelAdapter().typeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(ActivityHiveModelAdapter().typeId)) {
      Hive.registerAdapter(ActivityHiveModelAdapter());
    }
  }

  // BOOKING METHODS
  Future<void> createBooking(BookingsHiveModel booking) async {
    final box = await Hive.openBox<BookingsHiveModel>(
      HiveTableConstant.bookingsBox,
    );
    await box.put(booking.bookingId, booking);
    await box.close();
  }

  Future<void> updateBooking(
    String id,
    BookingsHiveModel updatedBooking,
  ) async {
    final box = await Hive.openBox<BookingsHiveModel>(
      HiveTableConstant.bookingsBox,
    );
    if (box.containsKey(id)) {
      await box.put(id, updatedBooking);
    } else {
      throw Exception('Booking with ID $id does not exist');
    }
    await box.close();
  }

  Future<List<BookingsHiveModel>> getMyBookings() async {
    final box = await Hive.openBox<BookingsHiveModel>(
      HiveTableConstant.bookingsBox,
    );
    final bookings = box.values.toList();
    await box.close();
    return bookings;
  }

  // GUIDE METHODS
  Future<void> cacheGuides(List<GuideHiveModel> guides) async {
    final box = await Hive.openBox<GuideHiveModel>(HiveTableConstant.guidesBox);
    await box.clear();
    for (var guide in guides) {
      await box.put(guide.guideId, guide);
    }
    await box.close();
  }

  Future<List<GuideHiveModel>> getCachedGuides() async {
    final box = await Hive.openBox<GuideHiveModel>(HiveTableConstant.guidesBox);
    final guides = box.values.toList();
    await box.close();
    return guides;
  }

  // USER METHODS
  Future<void> saveUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put('currentUser', user);
    await box.close();
  }

  Future<UserHiveModel?> getUser() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    final user = box.get('currentUser');
    await box.close();
    return user;
  }

  Future<void> clearAuthData() async {
    final userBox = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.userBox,
    );
    await userBox.clear();
    await userBox.close();
  }

  // FAVORITES METHODS
  Future<void> saveFavorites(List<ActivityHiveModel> favorites) async {
    final box = await Hive.openBox<ActivityHiveModel>(
      HiveTableConstant.favoritesBox,
    );
    await box.clear();
    for (var fav in favorites) {
      await box.put(fav.id, fav);
    }
    await box.close();
  }

  Future<List<ActivityHiveModel>> getFavorites() async {
    final box = await Hive.openBox<ActivityHiveModel>(
      HiveTableConstant.favoritesBox,
    );
    final favorites = box.values.toList();
    await box.close();
    return favorites;
  }

  Future<void> addFavorite(ActivityHiveModel activity) async {
    final box = await Hive.openBox<ActivityHiveModel>(
      HiveTableConstant.favoritesBox,
    );
    await box.put(activity.id, activity);
    await box.close();
  }

  Future<void> removeFavorite(String activityId) async {
    final box = await Hive.openBox<ActivityHiveModel>(
      HiveTableConstant.favoritesBox,
    );
    await box.delete(activityId);
    await box.close();
  }

  Future<void> clearFavorites() async {
    final box = await Hive.openBox<ActivityHiveModel>(
      HiveTableConstant.favoritesBox,
    );
    await box.clear();
    await box.close();
  }
}
