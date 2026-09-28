import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, typography, spacing } from '../tokens';

interface LinesCounterProps {
  count: number;
}

export default function LinesCounter({ count }: LinesCounterProps) {
  return (
    <View style={styles.container}>
      <Text style={styles.countText}>{count} LÍNEAS</Text>
      <Text style={styles.hintText}>Deslizá para borrar</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: spacing.lg,
    marginBottom: spacing.md,
  },
  countText: {
    fontSize: typography.fontSize.sectionHeader,
    fontWeight: typography.fontWeight.bold,
    color: colors.gray[600],
    letterSpacing: typography.letterSpacing.sectionHeader,
    marginBottom: spacing.xs,
  },
  hintText: {
    fontSize: typography.fontSize.footnote,
    color: colors.gray[400],
  },
});

