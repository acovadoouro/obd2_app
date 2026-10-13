import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dtc_service.dart';

class Obd2Manager extends ChangeNotifier {
  final DtcAiService _aiService = DtcAiService();

  bool _isDemoMode = true;
  bool _isScanning = false;
  bool _isConnected = false;
  String _connectionStatus = "Modo Demo Activo";

  int _rpm = 0;
  int _speed = 0;
  double _coolantTemp = 90.0;
  double _voltage = 14.2;

  String _codigoErrorDetectado = "";
  String _analisisIa = "";
  bool _cargandoDiagnostico = false;

  Timer? _demoTimer;
  double _timeCounter = 0.0;

  bool get isDemoMode => _isDemoMode;
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  String get connectionStatus => _connectionStatus;
  int get rpm => _rpm;
  int get speed => _speed;
  double get coolantTemp => _coolantTemp;
  double get voltage => _voltage;
  String get codigoErrorDetectado => _codigoErrorDetectado;
  String get analisisIa => _analisisIa;
  bool get cargandoDiagnostico => _cargandoDiagnostico;

  void toggleDemoMode(bool value) {
    _isDemoMode = value;
    if (_isDemoMode) {
      _isConnected = true;
      _connectionStatus = "Conectado (Simulador)";
      _startDemoData();
    } else {
      _isConnected = false;
      _connectionStatus = "Desconectado";
      _demoTimer?.cancel();
      _rpm = 0;
      _speed = 0;
      _codigoErrorDetectado = "";
      _analisisIa = "";
    }
    notifyListeners();
  }

  Future<void> escanearCodigosDeError() async {
    _cargandoDiagnostico = true;
    _analisisIa = "";
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    
    List<String> codigosComunes = ['P0300', 'P0420'];
    _codigoErrorDetectado = codigosComunes[Random().nextInt(codigosComunes.length)];
    _connectionStatus = "¡Código $_codigoErrorDetectado Detectado!";
    notifyListeners();

    _analisisIa = await _aiService.obtenerDiagnosticoHumano(_codigoErrorDetectado);
    _cargandoDiagnostico = false;
    notifyListeners();
  }

  void borarCodigosDeError() {
    _codigoErrorDetectado = "";
    _analisisIa = "";
    _connectionStatus = _isDemoMode ? "Conectado (Simulador)" : "Desconectado";
    notifyListeners();
  }

  void _startDemoData() {
    _demoTimer?.cancel();
    _demoTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _timeCounter += 0.05;
      double baseRpm = 2000 + sin(_timeCounter) * 1200;
      _rpm = (baseRpm + Random().nextInt(150) - 75).clamp(800, 6500).toInt();
      _speed = (40 + sin(_timeCounter * 0.5) * 35).clamp(0, 180).toInt();
      _coolantTemp = 90.0 + sin(_timeCounter * 0.1) * 2;
      _voltage = 14.1 + cos(_timeCounter * 0.2) * 0.2;
      notifyListeners();
    });
  }
}
