import React from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  ViewStyle,
  TextStyle,
  View,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, typography, spacing, borderRadius, shadows } from '../tokens';

type ButtonVariant = 'primary' | 'secondary' | 'danger';

interface ButtonProps {
  children: React.ReactNode;
  onPress?: () => void;
  variant?: ButtonVariant;
  disabled?: boolean;
  style?: ViewStyle;
  textStyle?: TextStyle;
  icon?: keyof typeof Ionicons.glyphMap;
}

export default function Button({
  children,
  onPress,
  variant = 'primary',
  disabled = false,
  style,
  textStyle,
  icon,
}: ButtonProps) {
  const getButtonStyle = () => {
    switch (variant) {
      case 'primary':
        return [styles.buttonPrimary, styles.buttonElevated];
      case 'secondary':
        return styles.buttonSecondary;
      case 'danger':
        return styles.buttonDanger;
      default:
        return styles.buttonPrimary;
    }
  };

  const getTextStyle = () => {
    switch (variant) {
      case 'primary':
        return styles.textPrimary;
      case 'secondary':
        return styles.textSecondary;
      case 'danger':
        return styles.textDanger;
      default:
        return styles.textPrimary;
    }
  };

  return (
    <TouchableOpacity
      style={[
        styles.button,
        getButtonStyle(),
        disabled && styles.buttonDisabled,
        style,
      ]}
      onPress={onPress}
      disabled={disabled}
      activeOpacity={0.7}
    >
      <View style={styles.buttonContent}>
        {icon && (
          <Ionicons
            name={icon}
            size={20}
            color={
              disabled
                ? colors.gray[500]
                : variant === 'primary' || variant === 'danger'
                  ? colors.white
                  : colors.gray[700]
            }
            style={styles.icon}
          />
        )}
        <Text
          style={[
            styles.text,
            getTextStyle(),
            disabled && styles.textDisabled,
            textStyle,
          ]}
        >
          {children}
        </Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    borderRadius: borderRadius.sm,
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.lg,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 48,
  },
  buttonContent: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  icon: {
    marginRight: spacing.sm,
  },
  buttonPrimary: {
    backgroundColor: colors.primary[500],
  },
  buttonSecondary: {
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.gray[300],
  },
  buttonDanger: {
    backgroundColor: colors.semantic.error.solid,
  },
  buttonElevated: {
    ...shadows.primaryButton,
  },
  buttonDisabled: {
    backgroundColor: colors.gray[300],
    shadowOpacity: 0,
    elevation: 0,
  },
  text: {
    fontSize: 15,
    fontWeight: typography.fontWeight.bold,
  },
  textPrimary: {
    color: colors.white,
  },
  textSecondary: {
    color: colors.gray[700],
  },
  textDanger: {
    color: colors.white,
  },
  textDisabled: {
    color: colors.gray[500],
  },
});

