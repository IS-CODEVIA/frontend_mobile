# SAUU - Features

## Autenticación (`auth/`)
Registro, inicio de sesión y pantalla de bienvenida. Punto de entrada único para ambos roles.

---

## Estudiantes

### `home_student/`
Dashboard del alumno. Muestra materias inscritas y acceso rápido a funciones.

### `general_noticies/`
Avisos generales publicados por la universidad.

### `assignment_notices/`
Avisos de tareas y trabajos de una materia específica.

### `material_students/`
Visualización y descarga de materiales de estudio por materia.

### `transcriptor_student/`
Grabación de voz y transcripción a texto para estudiantes.

### `people_student/`
Lista de compañeros inscritos en una materia.

### `settings_students/`
Configuración y preferencias del estudiante.

---

## Profesores

### `home_professor/`
Dashboard del profesor. Muestra las materias que imparte.

### `assignment_notices_professor/`
Creación y gestión de avisos de tareas por materia.

### `material_professor/`
Subida y gestión de materiales de estudio.

### `transcriptor_professor/`
Grabación de voz y transcripción a texto para profesores.

### `people_professor/`
Lista de alumnos inscritos en un curso.

### `settings_professor/`
Configuración y preferencias del profesor.

---

## Archivado (Estudiantes)

### `archived/`
Vista general de contenido archivado del alumno.

### `archived_assignment_notices/`
Avisos de tareas pasados (archivados).

### `archived_material_students/`
Materiales de estudio archivados.

### `archived_people_student/`
Listas de compañeros de ciclos anteriores.

---

## Archivado (Profesores)

### `archived_professor/`
Vista general de contenido archivado del profesor.

### `archived_assignment_notices_professor/`
Avisos de tareas pasados (archivados).

### `archived_material_professor/`
Materiales de estudio archivados.

### `archived_people_professor/`
Listas de alumnos de ciclos anteriores.

---

## Core (`lib/core/`)

| Módulo | Responsabilidad |
|---|---|
| `config/router.dart` | Configuración de rutas con GoRouter para ambos roles. |
| `di/app_container.dart` | Inicialización de la app e inyección de dependencias. |
| `network/api_client.dart` | Cliente HTTP para comunicación con la API REST. |
| `network/transcription_service.dart` | Servicio WebSocket para transcripción de audio. |
| `storage/token_storage.dart` | Persistencia de tokens de autenticación con SharedPreferences. |

## Shared (`lib/shared/`)

| Módulo | Responsabilidad |
|---|---|
| `theme/` | Temas Material 3 (claro, oscuro, alto contraste). |
| `widgets/` | Componentes reutilizables para estudiantes (headers, navbars). |
| `widgets_professor/` | Componentes reutilizables para profesores (headers, navbars). |
