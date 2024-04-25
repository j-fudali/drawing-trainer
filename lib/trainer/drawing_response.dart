
import 'package:json_annotation/json_annotation.dart';

part 'drawing_response.g.dart';

@JsonSerializable()
class DrawingResponse{
  final bool isValid;
  final int? rate;
  final List<String>? tips;

  DrawingResponse(this.isValid, this.rate, this.tips);

  factory DrawingResponse.fromJson(Map<String, dynamic> json) => _$DrawingResponseFromJson(json);
}