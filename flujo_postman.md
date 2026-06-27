# Flujo Completo API — Postman Collection

**Endpoint:** `POST http://localhost:8080/graphql`  
**Content-Type:** `application/json`  
**Puerto:** `8080`

Roles: `1` = student, `2` = teacher, `3` = admin

---

## 1. Registrar usuario teacher

**Headers:** ninguno

```json
{
  "query": "mutation($input: RegisterInput!) { register(input: $input) { user { userID name email roleID } accessToken refreshToken } }",
  "variables": {
    "input": {
      "email": "profesor@test.com",
      "password": "123456",
      "name": "Profesor Test",
      "roleID": 2
    }
  }
}
```

> Guardar `accessToken` y `refreshToken` de la respuesta.

---

## 2. Crear materia (subject) — requiere admin

**Headers:**
```
Authorization: Bearer <token_admin>
```

Si no hay admin, registrar uno con `roleID: 3` y usar su token.

```json
{
  "query": "mutation($input: CreateSubjectInput!) { createSubject(input: $input) { subjectID subjectCode subjectName description } }",
  "variables": {
    "input": {
      "subjectCode": "MATH101",
      "subjectName": "Matematicas I",
      "description": "Curso introductorio de matematicas"
    }
  }
}
```

> Guardar `subjectID`.

---

## 3. Login como teacher

**Headers:** ninguno

```json
{
  "query": "mutation($input: LoginInput!) { login(input: $input) { accessToken refreshToken } }",
  "variables": {
    "input": {
      "email": "profesor@test.com",
      "password": "123456"
    }
  }
}
```

> Usar este `accessToken` para los pasos 4, 5 y 6.

---

## 4. Crear course

**Headers:**
```
Authorization: Bearer <token_teacher>
```

```json
{
  "query": "mutation($input: CreateCourseInput!) { createCourse(input: $input) { courseID courseName section period joinCode subjectID teacherID createdAt } }",
  "variables": {
    "input": {
      "courseName": "Matematicas I - Grupo A",
      "section": "A",
      "period": "2026-1",
      "subjectID": 1
    }
  }
}
```

> Guardar `courseID` y `joinCode`.

---

## 5. Crear clase (class)

**Headers:**
```
Authorization: Bearer <token_teacher>
```

```json
{
  "query": "mutation($input: CreateClassInput!) { createClass(input: $input) { classID courseID dateTime topic createdAt } }",
  "variables": {
    "input": {
      "courseID": 1,
      "dateTime": "2026-06-27T10:00:00Z",
      "topic": "Introduccion a los numeros reales"
    }
  }
}
```

> Guardar `classID`.

---

## 6. (Opcional) Agregar material al course

**Headers:**
```
Authorization: Bearer <token_teacher>
```

```json
{
  "query": "mutation($input: CreateMaterialInput!) { createMaterial(input: $input) { materialID courseID title fileURL fileType createdAt } }",
  "variables": {
    "input": {
      "courseID": 1,
      "title": "Guia de estudio - Unidad 1",
      "fileURL": "https://ejemplo.com/guia1.pdf",
      "fileType": "pdf",
      "description": "Material de apoyo para la primera unidad"
    }
  }
}
```

---

## 7. Registrar un student

**Headers:** ninguno

```json
{
  "query": "mutation($input: RegisterInput!) { register(input: $input) { user { userID name email roleID } accessToken refreshToken } }",
  "variables": {
    "input": {
      "email": "alumno@test.com",
      "password": "123456",
      "name": "Alumno Test"
    }
  }
}
```

> `roleID` se omite → default `1` (student). Guardar su `accessToken`.

---

## 8. Inscribir alumno al curso (joinCourse)

**Headers:**
```
Authorization: Bearer <token_student>
```

```json
{
  "query": "mutation($joinCode: String!) { joinCourse(joinCode: $joinCode) { enrollmentID studentID courseID enrolledAt status } }",
  "variables": {
    "joinCode": "a1b2c3d4"
  }
}
```

> Usar el `joinCode` obtenido en el paso 4.

---

## 9. (Opcional) Crear transcripcion para la clase

**Headers:**
```
Authorization: Bearer <token_teacher>
```

```json
{
  "query": "mutation($input: CreateTranscriptionInput!) { createTranscription(input: $input) { transcriptionID classID fullText createdAt } }",
  "variables": {
    "input": {
      "classID": 1,
      "fullText": "En esta clase vimos los numeros reales, su clasificacion y propiedades fundamentales."
    }
  }
}
```

---

## Diagrama del flujo

```
User (role=teacher) ─── crea ───> Course ─── tiene ───> Class
                                    │                        │
                               Subject (materia)         Transcription
                                    │
                               User (role=admin) ─── crea

User (role=student) ─── joinCourse(joinCode) ───> Enrollment
```
