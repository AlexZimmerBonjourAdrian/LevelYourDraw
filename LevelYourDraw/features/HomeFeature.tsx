import { useState, useCallback } from 'react';

export interface Brief {
  id: string;
  titulo: string;
  consigna: string;
  categoria: string;
}

const SUGERENCIAS: Brief[] = [
  { id: '1', titulo: 'Cuatro datos', consigna: 'Define rol, epoca, rasgo y limite en una frase.', categoria: 'metodo' },
  { id: '2', titulo: 'Brief narrativo', consigna: 'Escribe que quiere, que teme y que oculta.', categoria: 'narrativa' },
  { id: '3', titulo: 'Estudio de estilo', consigna: 'Tres variantes de silueta con la misma paleta.', categoria: 'estilo' },
];

export function useBriefAleatorio() {
  const [brief, setBrief] = useState<Brief>(SUGERENCIAS[0]);
  const generar = useCallback(() => {
    setBrief(SUGERENCIAS[Math.floor(Math.random() * SUGERENCIAS.length)]);
  }, []);
  return { brief, generar };
}
