import React from 'react';
import { TextInput, StyleSheet, TextInputProps, ViewStyle } from 'react-native';
import { colors, spacing, borderRadius } from '../tokens';

interface InputFieldProps extends TextInputProps {
  style?: ViewStyle;
  error?: boolean;
}

export default function InputField({
  style,
  error = false,
  ...props
}: InputFieldProps) {
  return (
    <TextInput
      style={[styles.input, error && styles.inputError, style]}
      placeholderTextColor={colors.gray[400]}
      {...props}
    />
  );
}

const styles = StyleSheet.create({
  input: {
    backgroundColor: colors.gray[50],
    borderWidth: 1,
    borderColor: colors.gray[300],
    borderRadius: borderRadius.sm,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    fontSize: 15,
    color: colors.gray[800],
    minHeight: 44,
  },
  inputError: {
    borderColor: colors.semantic.error.border,
  },
});

