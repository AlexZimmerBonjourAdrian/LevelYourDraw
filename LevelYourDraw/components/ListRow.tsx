import React from 'react';
import {
  View,
  StyleSheet,
  ViewStyle,
  TouchableOpacity,
  StyleProp,
} from 'react-native';
import { colors, spacing, borderRadius } from '../tokens';

interface ListRowProps {
  children: React.ReactNode;
  style?: StyleProp<ViewStyle>;
  onPress?: () => void;
  disabled?: boolean;
}

export default function ListRow({
  children,
  style,
  onPress,
  disabled = false,
}: ListRowProps) {
  const Container = onPress ? TouchableOpacity : View;

  return (
    <Container
      style={[styles.row, disabled && styles.rowDisabled, style]}
      onPress={onPress}
      disabled={disabled}
      activeOpacity={onPress ? 0.7 : 1}
    >
      {children}
    </Container>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderRadius: borderRadius.md,
    padding: spacing.lg,
    borderWidth: 1,
    borderColor: colors.gray[200],
    minHeight: 44,
  },
  rowDisabled: {
    opacity: 0.5,
  },
});

