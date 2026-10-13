class DtcAiService {
  Future<String> obtenerDiagnosticoHumano(String codigoDtc) async {
    // Simula el tiempo de respuesta asíncrono de una petición de red a la IA
    await Future.delayed(const Duration(seconds: 2));
    return _obtenerRespuestaSimulada(codigoDtc);
  }

  String _obtenerRespuestaSimulada(String codigoDtc) {
    switch (codigoDtc.toUpperCase()) {
      case 'P0300':
        return "• ⚠️ **Significado:** Fallo de encendido en cilindros aleatorios.\n• 🔴 **Gravedad:** ALTA. No es seguro circular tramos largos; arriesgas dañar el catalizador.\n• 🔧 **Causas comunes:** Bujías viejas, bobinas de encendido fallando o cables defectuosos.\n• 💰 **Costo estimado:** \$80 - \$250 USD en taller.";
      case 'P0420':
        return "• ⚠️ **Significado:** Eficiencia del catalizador por debajo del umbral mínimo.\n• 🟡 **Gravedad:** MEDIA. El coche consume más gasolina y no pasará pruebas de emisiones.\n• 🔧 **Causas comunes:** Catalizador obstruido, fugas en el tubo de escape o sensor de oxígeno roto.\n• 💰 **Costo estimado:** \$150 - \$900 USD (la pieza del catalizador suele ser costosa).";
      default:
        return "• ⚠️ **Significado:** Código $codigoDtc registrado en la computadora central (ECU).\n• 🟡 **Gravedad:** MODERADA. Requiere un escaneo técnico detallado.\n• 🔧 **Causas comunes:** Lectura errática de un sensor o conectores eléctricos flojos.\n• 💰 **Costo estimado:** \$50 - \$150 USD por diagnóstico físico.";
    }
  }
}
