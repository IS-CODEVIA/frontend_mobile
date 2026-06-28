import 'package:flutter/material.dart';

const String _privacyPolicyContent = '''
AVISO DE PRIVACIDAD

Responsable

IS-CODEVIA, con domicilio en Suchiapa, Chiapas, Barrio San Francisco, es el responsable del uso y protección de sus datos personales, y al respecto le informamos lo siguiente.

Datos personales que recabamos

Para las finalidades descritas en el presente aviso de privacidad, recabamos las siguientes categorías de datos personales:

- Datos de identificación: nombre completo, correo electrónico, nombre de usuario, fotografía o avatar.
- Datos de contacto: correo electrónico.
- Datos académicos: historial de cursos, clases, materiales educativos, avisos, transcripciones y chat de clases.
- Datos de autenticación: contraseña (almacenada con cifrado), tokens de acceso y de renovación (JWT).

No recabamos ni tratamos datos personales sensibles (como origen étnico, salud, vida sexual, creencias religiosas, afiliación sindical u opiniones políticas).

Finalidades del tratamiento

Finalidades necesarias (que dan origen a la relación jurídica)

- Crear y administrar su cuenta de usuario en la plataforma educativa.
- Identificar y autenticar su identidad al acceder al sistema.
- Permitir la inscripción a cursos mediante código de acceso.
- Gestionar la creación, actualización y eliminación de cursos, clases, materiales y avisos educativos.
- Registrar y consultar transcripciones de clases y sesiones de chat.
- Asignar roles (estudiante, profesor, administrador) y controlar los permisos de acceso.
- Proveer los servicios educativos contratados o solicitados a través de la plataforma.
- Dar cumplimiento a obligaciones legales y regulatorias aplicables.

Finalidades secundarias (no necesarias para el servicio, pero que nos permiten mejorar su experiencia)

- Enviar comunicaciones sobre nuevos cursos, clases o materiales disponibles.
- Realizar análisis estadísticos y estudios internos sobre el uso de la plataforma para mejorar la calidad del servicio.
- Recordatorios automáticos de clases, avisos o eventos educativos.

Mecanismo para manifestar su negativa: En caso de que no desee que sus datos personales sean tratados para las finalidades secundarias, usted puede manifestar su negativa enviando un correo electrónico a [correo de contacto] indicando su nombre y la negativa expresa. La negativa para el uso de sus datos para estas finalidades no será motivo para negarle los servicios que solicita o contrata con nosotros.

Transferencias de datos personales

Le informamos que sus datos personales no son transferidos a terceros nacionales o internacionales fuera de los casos previstos por la ley, a menos que sea necesario para cumplir con una obligación legal o por requerimiento de autoridad competente.

En caso de requerir servicios de infraestructura en la nube (hosting), los datos podrán ser almacenados en servidores ubicados dentro o fuera del país, con proveedores que cumplen con los estándares de seguridad y protección de datos aplicables.

Derechos ARCO (Acceso, Rectificación, Cancelación y Oposición)

Usted tiene derecho a:

- Acceso: Conocer qué datos personales tenemos y para qué se usan.
- Rectificación: Solicitar la corrección de sus datos si están desactualizados, inexactos o incompletos.
- Cancelación: Solicitar la eliminación de sus datos cuando considere que no son necesarios para las finalidades señaladas.
- Oposición: Oponerse al tratamiento de sus datos para fines específicos.

Procedimiento para ejercer derechos ARCO

1. Enviar una solicitud por correo electrónico a: [correo electrónico para ARCO]
2. Incluir: nombre completo del titular, correo electrónico registrado en la plataforma, descripción clara del derecho que desea ejercer y, en su caso, la documentación que acredite la identidad o representación legal.
3. En un plazo máximo de 20 días hábiles contados desde la recepción de la solicitud, daremos respuesta indicando si procede o no.
4. La respuesta se comunicará al correo electrónico proporcionado en la solicitud.

Revocación del consentimiento

Usted puede revocar el consentimiento que nos haya otorgado para el tratamiento de sus datos personales en cualquier momento, sin que se le atribuyan efectos retroactivos.

Procedimiento para revocar el consentimiento

1. Enviar una solicitud por correo electrónico a: [correo electrónico para ARCO]
2. Incluir: nombre completo, correo electrónico registrado y la manifestación expresa de revocar su consentimiento.
3. En un plazo máximo de 20 días hábiles daremos respuesta y procederemos conforme a lo solicitado.

La revocación del consentimiento podría implicar la imposibilidad de seguir usando nuestros servicios.

Opciones para limitar el uso o divulgación de sus datos

Para limitar el uso o divulgación de sus datos personales, usted puede:

- Inscribirse en el Registro Público de Consumidores (REPECO) ante la Procuraduría Federal del Consumidor (PROFECO), en términos de la Ley Federal de Protección al Consumidor.
- Solicitar su inclusión en nuestro listado de exclusión interno enviando un correo a [correo de contacto] con el asunto "Exclusión de datos".
- Configurar las preferencias de notificaciones y comunicaciones directamente desde la aplicación.

Uso de cookies y tecnologías similares

Nuestra plataforma puede utilizar cookies, web beacons y otras tecnologías de seguimiento necesarias por motivos técnicos para:

- Mantener la sesión del usuario autenticada.
- Recordar preferencias del usuario (idioma, configuración de perfil).
- Recopilar datos anónimos de uso para mejorar la plataforma (como páginas visitadas, tiempo de sesión, funcionalidades más utilizadas).

No utilizamos cookies con fines publicitarios ni de prospección comercial.

Estas tecnologías pueden deshabilitarse desde la configuración del navegador o dispositivo móvil; sin embargo, algunas funcionalidades de la plataforma podrían verse afectadas.

Cambios al aviso de privacidad

Este aviso de privacidad puede sufrir modificaciones, cambios o actualizaciones derivadas de nuevos requerimientos legales, de nuestras propias necesidades del servicio, de nuestras prácticas de privacidad, de cambios en nuestro modelo de negocio, o por otras causas.

Nos comprometemos a mantenerlo informado sobre los cambios al presente aviso de privacidad a través de:

- Publicación en nuestro sitio web o aplicación.
- Notificación por correo electrónico a la dirección registrada en su cuenta.

El procedimiento para notificar cambios será la publicación del aviso actualizado en la plataforma con la fecha de última actualización.

Contacto

Para cualquier duda, comentario o ejercicio de sus derechos, puede contactarnos en:

- Correo electrónico: iscodevia@gmail.com
- Domicilio: Suchiapa, Chiapas, Barrio San Francisco

Última actualización: Junio 2026
''';

void showTermsDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Aviso de Privacidad',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: colorScheme.onSurface),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  _privacyPolicyContent,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.secondary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Cerrar',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
