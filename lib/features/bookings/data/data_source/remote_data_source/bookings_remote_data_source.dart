import 'package:dio/dio.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/core/network/api_service.dart';
import 'package:thrill_quest/features/bookings/data/data_source/bookings_data_source.dart';
import 'package:thrill_quest/features/bookings/data/model/bookings_api_model.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

class BookingsRemoteDataSource implements IBookingsDataSource {
  final ApiService _apiService;

  BookingsRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> createBooking(BookingsEntity booking) async {
    try {
      final model = BookingsApiModel.fromEntity(booking);
      final response = await _apiService.dio.post(
        ApiEndpoints.createBookings,
        data: model.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create booking: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Create booking failed: ${e.message}');
    } catch (e) {
      throw Exception('Create booking failed: $e');
    }
  }

  @override
  Future<void> updateBooking(String id, BookingsEntity booking) async {
    try {
      final model = BookingsApiModel.fromEntity(booking);
      final response = await _apiService.dio.put(
        '${ApiEndpoints.updateBookings}/$id',
        data: model.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update booking: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Update booking failed: ${e.message}');
    } catch (e) {
      throw Exception('Update booking failed: $e');
    }
  }

  @override
  Future<List<BookingsEntity>> getMyBookings() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getMyBookings);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((e) => BookingsApiModel.fromJson(e).toEntity())
            .toList();
      } else {
        throw Exception('Failed to fetch bookings: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Fetch bookings failed: ${e.message}');
    } catch (e) {
      throw Exception('Fetch bookings failed: $e');
    }
  }
}
