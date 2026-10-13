import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'obd2_manager.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<Obd2Manager>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabecera
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CORE OBD2 INTELLIGENCE',
                        style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: manager.isConnected ? Colors.greenAccent : Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            manager.connectionStatus,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: manager.isDemoMode,
                    activeColor: Colors.cyanAccent,
                    onChanged: (val) => manager.toggleDemoMode(val),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Telemetría Central (RPM y Velocidad)
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${manager.speed}',
                        style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0),
                      ),
                      const Text(
                        'KM/H',
                        style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 3),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${manager.rpm} RPM',
                        style: TextStyle(
                          color: manager.rpm > 5000 ? Colors.redAccent : Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Panel de Resultados de la IA
              if (manager.cargandoDiagnostico || manager.codigoErrorDetectado.isNotEmpty)
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16161F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: manager.cargandoDiagnostico ? Colors.cyanAccent.withOpacity(0.3) : Colors.white10),
                    ),
                    child: manager.cargandoDiagnostico
                        ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'DIAGNÓSTICO IA: ${manager.codigoErrorDetectado}',
                                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white30, size: 18),
                                      onPressed: () => manager.borarCodigosDeError(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  manager.analisisIa,
                                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),

              // Datos Secundarios Inferiores
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF16161F), borderRadius: BorderRadius.circular(12)),
                      child: Text('Motor: ${manager.coolantTemp.toStringAsFixed(1)} °C', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF16161F), borderRadius: BorderRadius.circular(12)),
                      child: Text('Batería: ${manager.voltage.toStringAsFixed(2)} V', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Botón de Acción Principal
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('ESCANEAR AVERÍAS CON IA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                onPressed: manager.cargandoDiagnostico ? null : () => manager.escanearCodigosDeError(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
