# Constitucion tecnica — LevelYourDraw

Decisiones permanentes de la app. Toda IA las carga antes de generar codigo.

## Innegociables

- **Offline primero.** La app funciona sin backend: los briefs se generan en el dispositivo. Si hay servidor, es opcional y nunca bloquea.
- **El generador no repite consigna en la sesion.** Nada de azar puro sin memoria: cada brief sale de un mazo con descarte por sesion.
- Todo cambio de comportamiento actualiza `PLAN.md` en el mismo cambio.

## Arquitectura

- React Native con Expo, development build. Nunca Expo Go.
- Capas: pantallas (sin logica) -> `features/` (casos de uso) -> servicios (`export/`, `camera/`). Componentes en `components/`, tokens en modulo unico.
- Configuracion (endpoint opcional, banderas) por variable de entorno. Nunca hardcodeada.
- Solo se persiste en dispositivo: preferencias, galeria de retos y ultimos briefs. Nada mas.

## Codigo

- TypeScript estricto, sin `any` para salir del paso.
- Valores de diseno copiados del sistema de diseno, no redondeados.
- Area tactil minima 44x44. Sin emojis en codigo ni UI.

## Seguridad

- Ningun secreto en el repositorio. Solo `.env.example` con valores de relleno.
- Sin datos del usuario en logs de entrega. Logs de red solo en desarrollo.
- Todo trafico por HTTPS. Enlaces externos en navegador del sistema.
- Permisos minimos: camara y galeria solo cuando la funcion los exige, con explicacion previa.

## Entrega

- `main` solo via Pull Request. Commits `tipo: descripcion`, minuscula e imperativo.
- Ningun agente hace `commit` ni `push` sin orden explicita.
- Pie de version obligatorio en todo build (version, fecha, hash).



