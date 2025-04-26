part of 'view_detail_bloc.dart';

@immutable
sealed class ViewDetailEvent {}

class GetBookingDetailEvent extends ViewDetailEvent {
  final int bookingId;

  GetBookingDetailEvent({required this.bookingId});
}
