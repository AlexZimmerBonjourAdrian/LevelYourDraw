# Los cuatro datos — mecanica central del MVP

El MVP es el generador de cuatro datos. Todo lo demas (PNG, captura,
galeria) existe para servir a esta mecanica.

## Los cuatro datos

1. **Rol** (rol en la historia): peso narrativo o funcion (protagonista, terciario, antagonista, mentor...), un sustantivo.
   Ej: Heroe, Traidor, Mentor. NO es ocupacion.
2. **Profesion** (1 o 2, maximo dos): ocupacion concreta. Si salen dos,
   **la primera domina el diseno** y la segunda es acento.
   Ej: Ingeniero informatico, Estudiante universitario. Pluriverbal permitido.
3. **Mood interno** (como se percibe el): UNA palabra. Ej: Roto, Ambicioso.
4. **Mood externo** (como lo perciben los demas): UNA palabra. Ej: Temido, Querido.

La gracia esta en la tension interno/externo: el hueco entre como se ve el
personaje y como lo ve el mundo ES la historia a dibujar
(ej: interno Valiente + externo Temido = heroe temido por los suyos).

## Reglas

- Rol y profesion nunca se solapan: rol = arquetipo, profesion = oficio.
  Si una carta sirve para ambas listas, va solo a una.
- Moods de una palabra, dibujables: pasan el test "se puede dibujar?".
  Nada abstracto sin lectura visual.
- Segunda profesion con 25% de probabilidad; la primera manda en silueta.
- Sin repeticion en sesion (descarte; se resetea al agotar).
- Mazos en `data/cuatro_datos.{es,en}.json`: 54 roles, 60 profesiones,
  60 interno, 60 externo por idioma = 11,6M de combinaciones.
- Traduccion conceptual 1:1, no literal. Listas independientes por idioma.

## Evaluacion de la propuesta

- Rol x profesion evita el cliche ("guerrero elfo"): la originalidad sale
  del cruce, no del talento del usuario.
- Interno/externo es el diferencial real vs generadores random.
- Riesgo: listas rol/profesion que se mezclan; se contiene con la regla de
  no-solapamiento de arriba.
- Riesgo: volumen de contenido como costo S1; contenido con los tamanos
  actuales (suficientes por combinatoria) salvo que el dogfooding pida mas.

## Casos canonicos (rol x profesion son ortogonales)

- Protagonista x Granjero: la historia gira en torno a alguien comun.
- Personaje terciario x CEO: poder alto, peso narrativo bajo.
- Antagonista x Pescador: el mal con oficio humilde, sin uniforme de villano.

Cualquier cruce vale. Si un cruce "no tiene sentido", es un buen brief:
la friccion es el ejercicio.


