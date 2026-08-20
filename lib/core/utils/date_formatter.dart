class DateFormatter {
  DateFormatter._();

  static const List<String> _meses = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  static String fechaLegible(DateTime fecha) {
    return '${fecha.day} de ${_meses[fecha.month - 1]} de ${fecha.year}';
  }

  static String tiempoRelativo(DateTime fecha) {
    final diferencia = DateTime.now().difference(fecha);

    if (diferencia.inDays == 0) return 'Hoy';
    if (diferencia.inDays == 1) return 'Ayer';
    if (diferencia.inDays < 7) return 'Hace ${diferencia.inDays} días';
    if (diferencia.inDays < 30) {
      return 'Hace ${(diferencia.inDays / 7).floor()} semanas';
    }
    return fechaLegible(fecha);
  }
}