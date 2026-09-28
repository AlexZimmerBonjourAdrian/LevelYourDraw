import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, typography, spacing, borderRadius } from '../tokens';

interface InfoMessageProps {
  message: string;
}

export default function InfoMessage({ message }: InfoMessageProps) {
  return (
    <View style={styles.container}>
      <Ionicons
        name="information-circle"
        size={20}
        color={colors.primary[500]}
        style={styles.icon}
      />
      <Text style={styles.message}>{message}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: colors.primary[50],
    borderRadius: borderRadius.md,
    padding: spacing.md,
    marginHorizontal: spacing.lg,
    marginBottom: spacing.lg,
    alignItems: 'flex-start',
  },
  icon: {
    marginRight: spacing.sm,
    marginTop: 2,
  },
  message: {
    flex: 1,
    fontSize: typography.fontSize.footnote,
    color: colors.gray[700],
    lineHeight: typography.lineHeight.body,
  },
});

