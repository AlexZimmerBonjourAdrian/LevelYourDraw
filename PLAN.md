# PLAN — LevelYourDraw

Generador de briefs y retos de diseno de personajes (Android). Entrenador metodologico de bolsillo contra el bloqueo creativo. Referencia: Wanna Draw; diferencia: metodologias de produccion (4 datos, brief narrativo, estudio de estilo) + exportacion PNG y modo captura para redes. Bilingue ESP/ENG desde el dia uno.

**Calendario:** 3 semanas, 1 h/dia, todos los dias = **21 h totales**.
**Actualizacion:** 2026-09-28 (re-enfoque: alcance y calendario realistas a 21 h).

## Reglas

- Hito = unidad minima demostrable. Estados: `pendiente` -> `en implementacion` -> `en revision` -> `validado`.
- Quien mueve una tarea actualiza este archivo en el mismo cambio.
- Sin backend obligatorio: todo hito demuestra offline. El servidor, si existe, es opcional.

## Hitos (7 h por semana)

### S1 · Generador (7 h) — `en implementacion`
Base ya existente: tabs Inicio/Galeria/Captura/Ajustes, UI kit, tokens, Inicio funcional. Falta:

- [x] Mecanica cuatro datos documentada (`docs/CUATRO_DATOS.md`) + mazos JSON ES/EN (54/60/60/60, 11,6M combos)
- [x] Generador con descarte por sesion + toggle ES/EN + giro suave + nota de dominancia (hecho, verificado en codigo)
- [ ] Historial de sesion + guardar favorito (2 h)
- [ ] Persistencia local: ultimos briefs y favoritos (1 h)

Demostrable: 7 dias seguidos generan briefs sin repetir en sesion.

### S2 · Exportar y capturar (7 h) — `pendiente`

> Decision de entrada obligatoria: exportar PNG y hoja de compartir exigen
> modulos fuera de Expo Go (`expo-sharing`, captura de vista). La camara SI
> funciona en Go. Al iniciar S2 se decide: (a) reintroducir dev-client, o
> (b) recortar comparticion ya (aplica la contingencia). Sin esta decision,
> S2 no arranca.
- [ ] Exportar card en PNG transparente (3 h)
- [ ] Modo captura: foto + consigna como marca de agua/sticker (3 h)
- [ ] Hoja de compartir + sticker posicionable (1 h, segun `docs/TABS.md` tab Captura)

Demostrable: PNG superpuesto en app de dibujo + foto con reto integrado.

### S3 · Galeria y cierre (7 h) — `pendiente`
- [ ] Galeria local de retos guardados y terminados (3 h)
- [ ] Pulido: vibracion on/off en Ajustes + area tactil 44x44 + pie de version (2 h)
- [ ] Instalable firmado Android + nota de traspaso (2 h)

Demostrable: APK instalable con version visible.

## Backlog pago (ver `docs/PRO.md`)

Customizacion (mazos propios, fijar datos, baneos), boards tematicos con
paleta, restricciones finas (tiempo, formato, tecnica), colecciones y
export HD. Solo despues de validar la gratis a 30 dias.

## Fuera de alcance (decision, no omision)

- Backend/cuentas/sincronizacion en la nube.
- Suite de testing automatizado en este ciclo.
- iOS (solo Android en estas 3 semanas).
- Pagos, impresion, multiusuario.

## Contingencia de alcance (regla de corte)

Si a las 21 h el proyecto no esta terminado, se recorta —no se extiende—:
se elimina el modulo de comparticion en redes (modo captura/showcase + hoja
de compartir) y la app queda en su minimo: generador de briefs + exportacion
PNG + galeria local. Lo cortado pasa a backlog, no a deuda.

## Dogfooding

El creador es artista y usa la app como practica diaria real durante las
3 semanas. Eso sustituye al testing formal de este ciclo: cada sesion de
practica es una sesion de QA (briefs repetidos, PNG rotos, friccion de uso
se registran como defectos en el mismo cambio).











