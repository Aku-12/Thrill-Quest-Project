import 'package:thrill_quest/core/network/hive_service.dart';
import 'package:thrill_quest/features/bookings/data/data_source/bookings_data_source.dart';
import 'package:thrill_quest/features/bookings/data/model/bookings_hive_model.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

class BookingsLocalDataSource implements IBookingsDataSource {
  final HiveService _hiveService;

  BookingsLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> createBooking(BookingsEntity booking) async {
    try {
      final model = BookingsHiveModel.fromEntity(booking);
      await _hiveService.createBooking(model);
    } catch (e) {
      throw Exception('Local create booking failed: $e');
    }
  }

  @override
  Future<void> updateBooking(String id, BookingsEntity booking) async {
    try {
      final model = BookingsHiveModel.fromEntity(booking);
      await _hiveService.updateBooking(id, model);
    } catch (e) {
      throw Exception('Local update booking failed: $e');
    }
  }

  @override
  Future<List<BookingsEntity>> getMyBookings() async {
    try {
      final localModels = await _hiveService.getMyBookings();
      return localModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception('Local fetch bookings failed: $e');
    }
  }
}
