import React from 'react';
import { TouchableOpacity, StyleSheet, ViewStyle } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, spacing, borderRadius } from '../tokens';

interface CircularButtonProps {
  iconName: keyof typeof Ionicons.glyphMap;
  onPress: () => void;
  style?: ViewStyle;
  size?: number;
  color?: string;
  backgroundColor?: string;
}

export default function CircularButton({
  iconName,
  onPress,
  style,
  size = 40,
  color = colors.primary[500],
  backgroundColor = colors.gray[100],
}: CircularButtonProps) {
  return (
    <TouchableOpacity
      style={[
        styles.button,
        {
          width: size,
          height: size,
          borderRadius: size / 2,
          backgroundColor,
        },
        style,
      ]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      <Ionicons name={iconName} size={size * 0.5} color={color} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: 44,
    minHeight: 44,
  },
});

