// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawingResponse _$DrawingResponseFromJson(Map<String, dynamic> json) =>
    DrawingResponse(
      json['isValid'] as bool,
      json['rate'] as int,
      (json['tips'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DrawingResponseToJson(DrawingResponse instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'rate': instance.rate,
      'tips': instance.tips,
    };
