import React from 'react';
import { View, StyleSheet, ViewStyle, StyleProp } from 'react-native';
import { colors, spacing, borderRadius } from '../tokens';

type CardVariant = 'section' | 'list';

interface CardProps {
  children: React.ReactNode;
  variant?: CardVariant;
  style?: StyleProp<ViewStyle>;
}

export default function Card({
  children,
  variant = 'section',
  style,
}: CardProps) {
  return <View style={[styles.card, styles[variant], style]}>{children}</View>;
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.white,
  },
  section: {
    borderRadius: borderRadius.md,
    padding: spacing.lg,
  },
  list: {
    borderRadius: borderRadius.md,
    padding: spacing.lg,
    marginBottom: spacing.sm,
    borderWidth: 1,
    borderColor: colors.gray[200],
  },
});

