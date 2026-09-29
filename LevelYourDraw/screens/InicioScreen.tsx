import React, { useState, useRef, useEffect } from 'react';
import { Text, View, Animated, Vibration, StyleSheet } from 'react-native';
import { useCuatroDatos, type Idioma, type CuatroDatos } from '../features/HomeFeature';
import es from '../data/cuatro_datos.es.json';
import en from '../data/cuatro_datos.en.json';
import Button from '../components/Button';
import Card from '../components/Card';
import SegmentedControl from '../components/SegmentedControl';
import { colors, spacing, typography } from '../tokens';

const ETIQUETAS = {
  es: {
    titulo: 'Tu brief de hoy', subtitulo: 'Cuatro datos, un personaje',
    rol: 'Rol', prof: 'Profesión', domina: 'domina', inter: 'Por dentro', exter: 'Por fuera',
    nuevo: 'Nuevo brief', mas: 'Explorar metodos',
  },
  en: {
    titulo: 'Your brief for today', subtitulo: 'Four facts, one character',
    rol: 'Role', prof: 'Profession', domina: 'leads', inter: 'Inside', exter: 'Outside',
    nuevo: 'New brief', mas: 'Explore methods',
  },
} as const;

type T = (typeof ETIQUETAS)[Idioma];
const MAZOS = { es, en };

function MiniDato({
  etiqueta, valor, mazo, giro,
}: {
  etiqueta: string;
  valor: string;
  mazo: string[];
  giro: number;
}) {
  const [visible, setVisible] = useState(valor);
  const opacidad = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    if (giro === 0) {
      setVisible(valor);
      return;
    }
    const intervalo = setInterval(() => {
      setVisible(mazo[Math.floor(Math.random() * mazo.length)]);
    }, 70);
    const fin = setTimeout(() => {
      clearInterval(intervalo);
      setVisible(valor);
      Animated.sequence([
        Animated.timing(opacidad, { toValue: 0.35, duration: 90, useNativeDriver: true }),
        Animated.timing(opacidad, { toValue: 1, duration: 160, useNativeDriver: true }),
      ]).start();
    }, 420);
    return () => {
      clearInterval(intervalo);
      clearTimeout(fin);
    };
  }, [giro]);

  useEffect(() => {
    if (giro === 0) setVisible(valor);
  }, [valor]);

  return (
    <Animated.View style={[styles.mini, { opacity: opacidad }]}>
      <Text style={styles.etiqueta}>{etiqueta}</Text>
      <Text style={styles.valor}>{visible}</Text>
    </Animated.View>
  );
}

function mazos(b: CuatroDatos, t: T, idioma: Idioma): Array<[string, string, string[]]> {
  const m = MAZOS[idioma];
  return [
    [t.rol, b.rol, m.rol],
    [t.prof, b.profesionSecundaria ? `${b.profesion} + ${b.profesionSecundaria}` : b.profesion, m.profesion],
    [t.inter, b.interno, m.interno],
    [t.exter, b.externo, m.externo],
  ];
}

export function InicioScreen() {
  const [idioma, setIdioma] = useState<Idioma>('es');
  const [giro, setGiro] = useState(0);
  const { brief, generar } = useCuatroDatos(idioma);
  const t = ETIQUETAS[idioma];
  const sacar = () => {
    Vibration.vibrate(10);
    generar();
    setGiro((g) => g + 1);
  };
  return (
    <View style={styles.pantalla}>
      <Text style={styles.titulo}>LevelYourDraw</Text>
      <Text style={styles.subtitulo}>{t.titulo} — {t.subtitulo}</Text>
      <SegmentedControl
        options={['es', 'en']}
        selectedOption={idioma}
        onSelect={(o) => setIdioma(o as Idioma)}
      />
      <Card>
        <View style={styles.grilla}>
          {mazos(brief, t, idioma).map(([etiqueta, valor, mazo], i) => (
            <MiniDato key={`${idioma}-${i}`} etiqueta={etiqueta} valor={valor} mazo={mazo} giro={giro} />
          ))}
        </View>
        {brief.profesionSecundaria ? (
          <Text style={styles.nota}>{t.prof} {t.domina}: {brief.profesion}</Text>
        ) : null}
      </Card>
      <Button onPress={sacar}>{t.nuevo}</Button>
      <Button variant="secondary" onPress={sacar}>{t.mas}</Button>
    </View>
  );
}

const styles = StyleSheet.create({
  pantalla: { flex: 1, padding: spacing.lg, gap: spacing.md },
  titulo: {
    fontSize: typography.fontSize.sectionHeader,
    fontWeight: typography.fontWeight.bold,
    letterSpacing: typography.letterSpacing.sectionHeader,
    color: colors.gray[800],
  },
  subtitulo: { fontSize: typography.fontSize.footnote, color: colors.gray[500] },
  grilla: { flexDirection: 'row', flexWrap: 'wrap', gap: spacing.sm },
  mini: {
    flexBasis: '48%',
    flexGrow: 1,
    backgroundColor: colors.gray[50],
    borderRadius: 12,
    padding: spacing.md,
    gap: 4,
  },
  etiqueta: {
    fontSize: typography.fontSize.chip,
    fontWeight: typography.fontWeight.semiBold,
    color: colors.gray[500],
  },
  valor: { fontSize: typography.fontSize.body, fontWeight: typography.fontWeight.bold, color: colors.gray[800] },
  nota: { fontSize: typography.fontSize.footnote, color: colors.gray[500], marginTop: spacing.sm },
});
