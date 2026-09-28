import React from 'react';
import { View, StyleSheet, ViewStyle } from 'react-native';
import { colors, borderRadius, shadows, spacing } from '../tokens';

interface BottomSheetProps {
  children: React.ReactNode;
  style?: ViewStyle;
}

export default function BottomSheet({ children, style }: BottomSheetProps) {
  return (
    <View style={[styles.sheet, style]}>
      <View style={styles.handle} />
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  sheet: {
    backgroundColor: colors.white,
    borderTopLeftRadius: borderRadius.xl,
    borderTopRightRadius: borderRadius.xl,
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.sm,
    paddingBottom: spacing.safeAreaBottom,
    ...shadows.sheet,
  },
  handle: {
    width: 40,
    height: 4,
    backgroundColor: colors.gray[300],
    borderRadius: 2,
    alignSelf: 'center',
    marginBottom: spacing.lg,
  },
});

