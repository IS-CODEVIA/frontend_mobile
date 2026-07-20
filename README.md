# SAUU Mobile — Transcriptor en Vivo

Aplicación móvil multiplataforma desarrollada en **Flutter** para la **Universidad Politécnica de Chiapas (UPChiapas)** que funciona como asistente académico para estudiantes y docentes, destacando su **módulo de transcripción en vivo** diseñado para apoyar a personas con discapacidad auditiva.

## Transcripción en Vivo (Inclusión para Personas Sordas)

El módulo de **transcripción en tiempo real** permite a los estudiantes con discapacidad auditiva seguir las clases sin depender exclusivamente del lenguaje de señas o la lectura de labios. Los docentes activan la transcripción desde su dispositivo y el audio se convierte a texto que los estudiantes visualizan en tiempo real a través de WebSocket.

**Flujo de uso:**
1. El **docente** inicia la grabación de audio en su dispositivo desde la vista de transcriptor
2. El audio se envía a un servicio de transcripción vía WebSocket (`wss://.../ws/transcribe`)
3. Los resultados parciales y finales se transmiten a los **estudiantes** conectados a la misma clase
4. Los estudiantes visualizan el texto transcrito en pantalla, con opción de historial y chat para interactuar con el docente

## Características Principales

### Para Estudiantes
- Panel principal con materias inscritas
- Unirse a clase mediante código generado por el docente
- **Transcripción en vivo** de clases
- Visualización de materiales de estudio por unidad
- Avisos y notificaciones por materia
- Lista de compañeros y docente
- Avisos generales universitarios
- Contenido archivado de ciclos anteriores

### Para Docentes
- Panel principal con materias impartidas
- Creación de clases con generación de código de acceso
- **Grabación y transmisión de transcripción en vivo**
- Gestión de materiales de estudio (subida y organización)
- CRUD de avisos por materia
- Visualización de estudiantes inscritos
- Contenido archivado de ciclos anteriores

## Stack Tecnológico

| Tecnología | Versión |
|---|---|
| **Flutter** | SDK `^3.7.0` |
| **Dart** | `^3.7.0` |
| **Riverpod** | `^3.3.2` (manejo de estado) |
| **GoRouter** | `^14.8.0` (enrutamiento) |
| **GraphQL** | API REST en `https://sauu.store/graphql` |
| **WebSocket** | Transcripción en tiempo real |
| **SharedPreferences** | Almacenamiento local de JWT |
| **Google Fonts** | Poppins + Nunito |
| **record** | `^5.2.1` (grabación de audio) |

## Arquitectura

El proyecto sigue **Clean Architecture** con 3 capas por feature:

```
feature/
├── data/           # Fuentes de datos (GraphQL, modelos, repositorios)
├── domain/         # Entidades, interfaces de repositorio, casos de uso
└── presentation/   # Pantallas, widgets, providers (Riverpod)
```

### Plataformas Soportadas

- Android
- iOS
- Web
- Linux
- macOS
- Windows

## Esquema de Navegación

- `/` — Pantalla de bienvenida
- `/login` — Inicio de sesión (selección de rol: Alumno/Docente)
- `/register` — Registro de usuario
- `/home` — Dashboard de estudiante
- `/professor-home` — Dashboard de docente
- `/transcriptor/:subjectName` — Transcriptor en vivo (estudiante)
- `/professor-transcriptor/:subjectName` — Transcriptor en vivo (docente)

## Backend

- **API:** GraphQL en `https://sauu.store/graphql`
- **WebSocket:** `wss://e6omtu6oi9j7p7-8000.proxy.runpod.net/ws/transcribe`
- **Autenticación:** JWT (access + refresh tokens)

## Estado del Proyecto

Versión `2.0.3+5` — Proyecto activo, preparado para publicación en producción (keystore de firma Android incluido).
