import React from 'react';
import { View, Text, StyleSheet, ViewStyle } from 'react-native';
import { colors, typography, borderRadius, spacing } from '../tokens';

type StatusVariant = 'success' | 'warning' | 'error' | 'neutral' | 'info';

interface StatusChipProps {
  children: React.ReactNode;
  variant?: StatusVariant;
  style?: ViewStyle;
}

export default function StatusChip({
  children,
  variant = 'neutral',
  style,
}: StatusChipProps) {
  const getColors = () => {
    switch (variant) {
      case 'success':
        return {
          backgroundColor: colors.semantic.success.bg,
          textColor: colors.semantic.success.text,
        };
      case 'warning':
        return {
          backgroundColor: colors.semantic.warning.bg,
          textColor: colors.semantic.warning.text,
        };
      case 'error':
        return {
          backgroundColor: colors.semantic.error.bg,
          textColor: colors.semantic.error.text,
        };
      case 'info':
        return {
          backgroundColor: colors.primary[50],
          textColor: colors.primary[800],
        };
      case 'neutral':
      default:
        return {
          backgroundColor: colors.gray[100],
          textColor: colors.gray[600],
        };
    }
  };

  const { backgroundColor, textColor } = getColors();

  return (
    <View style={[styles.chip, { backgroundColor }, style]}>
      <Text style={[styles.chipText, { color: textColor }]}>{children}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  chip: {
    borderRadius: borderRadius.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    alignSelf: 'flex-start',
  },
  chipText: {
    fontSize: typography.fontSize.chip,
    fontWeight: typography.fontWeight.semiBold,
  },
});

