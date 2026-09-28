import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import { colors, typography, spacing, borderRadius } from '../tokens';

interface SegmentedControlProps {
  options: string[];
  selectedOption: string;
  onSelect: (option: string) => void;
  style?: ViewStyle;
}

export default function SegmentedControl({
  options,
  selectedOption,
  onSelect,
  style,
}: SegmentedControlProps) {
  return (
    <View style={[styles.container, style]}>
      {options.map((option) => (
        <TouchableOpacity
          key={option}
          style={[
            styles.option,
            selectedOption === option && styles.optionActive,
          ]}
          onPress={() => onSelect(option)}
          activeOpacity={0.7}
        >
          <Text
            style={[
              styles.optionText,
              selectedOption === option && styles.optionTextActive,
            ]}
          >
            {option}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: colors.gray[100],
    borderRadius: borderRadius.sm,
    padding: spacing.xs,
  },
  option: {
    flex: 1,
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
    borderRadius: borderRadius.sm,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 36,
  },
  optionActive: {
    backgroundColor: colors.white,
  },
  optionText: {
    fontSize: typography.fontSize.body,
    fontWeight: typography.fontWeight.medium,
    color: colors.gray[600],
  },
  optionTextActive: {
    color: colors.gray[800],
    fontWeight: typography.fontWeight.semiBold,
  },
});

