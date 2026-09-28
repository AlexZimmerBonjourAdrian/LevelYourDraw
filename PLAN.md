# PLAN — LevelYourDraw

Generador de briefs y retos de diseno de personajes (Android). Entrenador metodologico de bolsillo contra el bloqueo creativo. Referencia: Wanna Draw; diferencia: metodologias de produccion (4 datos, brief narrativo, estudio de estilo) + exportacion PNG y modo captura para redes.

**Calendario:** 3 semanas, 1 h/dia, todos los dias = **21 h totales**.
**Actualizacion:** 2026-09-28 (re-enfoque: alcance y calendario realistas a 21 h).

## Reglas

- Hito = unidad minima demostrable. Estados: `pendiente` -> `en implementacion` -> `en revision` -> `validado`.
- Quien mueve una tarea actualiza este archivo en el mismo cambio.
- Sin backend obligatorio: todo hito demuestra offline. El servidor, si existe, es opcional.

## Hitos (7 h por semana)

### S1 · Generador (7 h) — `en implementacion`
Base ya existente: tabs Inicio/Galeria/Ajustes, UI kit, tokens. Falta:

- [ ] Mazo de briefs con descarte por sesion: 4 datos + narrativo + estudio de estilo (3 h)
- [ ] Pantalla de brief: card de consigna + boton nuevo brief + historial de sesion (2 h)
- [ ] Persistencia local: ultimos briefs y favoritos (2 h)

Demostrable: 7 dias seguidos generan briefs sin repetir en sesion.

### S2 · Exportar y capturar (7 h) — `pendiente`
- [ ] Exportar card en PNG transparente (3 h)
- [ ] Modo captura: foto + consigna como marca de agua/sticker (3 h)
- [ ] Hoja de compartir del sistema (1 h)

Demostrable: PNG superpuesto en app de dibujo + foto con reto integrado.

### S3 · Galeria y cierre (7 h) — `pendiente`
- [ ] Galeria local de retos guardados y terminados (3 h)
- [ ] Pulido: area tactil 44x44, sin emojis, pie de version (2 h)
- [ ] Instalable firmado Android + nota de traspaso (2 h)

Demostrable: APK instalable con version visible.

## Fuera de alcance (decision, no omision)

- Backend/cuentas/sincronizacion en la nube.
- Suite de testing automatizado en este ciclo.
- iOS (solo Android en estas 3 semanas).
- Pagos, impresion, multiusuario.
