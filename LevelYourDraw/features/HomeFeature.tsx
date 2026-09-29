import { useState, useCallback, useRef } from 'react';
import es from '../data/cuatro_datos.es.json';
import en from '../data/cuatro_datos.en.json';

export type Idioma = 'es' | 'en';
export interface CuatroDatos {
  rol: string;
  profesion: string;
  profesionSecundaria: string | null;
  interno: string;
  externo: string;
}

const MAZOS = { es, en };

function alAzar<T>(lista: T[]): T {
  return lista[Math.floor(Math.random() * lista.length)];
}

function generarCombo(idioma: Idioma): CuatroDatos {
  const mazo = MAZOS[idioma];
  const segunda = Math.random() < 0.25 ? alAzar(mazo.profesion) : null;
  return {
    rol: alAzar(mazo.rol),
    profesion: alAzar(mazo.profesion),
    profesionSecundaria: segunda === null ? null : segunda,
    interno: alAzar(mazo.interno),
    externo: alAzar(mazo.externo),
  };
}

function clave(c: CuatroDatos): string {
  return [c.rol, c.profesion, c.profesionSecundaria, c.interno, c.externo].join('|');
}

export function useCuatroDatos(idioma: Idioma = 'es') {
  const [brief, setBrief] = useState<CuatroDatos>(() => generarCombo(idioma));
  const usados = useRef<Set<string>>(new Set());
  const generar = useCallback(() => {
    let siguiente = generarCombo(idioma);
    let intentos = 0;
    while (usados.current.has(clave(siguiente)) && intentos < 20) {
      siguiente = generarCombo(idioma);
      intentos += 1;
    }
    usados.current.add(clave(siguiente));
    setBrief(siguiente);
  }, [idioma]);
  return { brief, generar };
}
