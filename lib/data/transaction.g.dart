// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionDataAdapter extends TypeAdapter<TransactionData> {
  @override
  final int typeId = 2;

  @override
  TransactionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionData(
      amount: fields[0] as double,
      time: fields[1] as String,
      note: fields[2] as String,
      type: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
