import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  type StyleProp,
  type ViewStyle,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, borderRadius, spacing, typography } from '../tokens';
import DropdownModal from './DropdownModal';

export interface PickerOption<
  T extends string | number | undefined = string | number | undefined,
> {
  label: string;
  value: T;
}

interface PickerFilterProps<T extends string | number | undefined> {
  label: string;
  options: PickerOption<T>[];
  selectedValue?: T;
  onSelect: (value: T) => void;
  disabled?: boolean;
  /**
   * `outline` (defecto): píldora blanca con borde.
   * `filled`: píldora sólida en color primario (filtro principal activo).
   */
  variant?: 'outline' | 'filled';
  /**
   * En modo compacto se muestra una sola línea (valor seleccionado o
   * etiqueta) en lugar de etiqueta + valor.
   */
  compact?: boolean;
  style?: StyleProp<ViewStyle>;
}

export default function PickerFilter<T extends string | number | undefined>({
  label,
  options,
  selectedValue,
  onSelect,
  disabled = false,
  variant = 'outline',
  compact = false,
  style,
}: PickerFilterProps<T>) {
  const [visible, setVisible] = useState(false);

  const selectedOption = options.find(
    (option) => option.value === selectedValue
  );
  const filled = variant === 'filled';

  const handleSelect = (value: string | number | undefined) => {
    onSelect(value as T);
    setVisible(false);
  };

  const chevronColor = disabled
    ? colors.gray[300]
    : filled
      ? colors.white
      : colors.gray[600];

  return (
    <View
      style={[
        styles.container,
        compact && styles.containerCompact,
        filled && styles.containerFilled,
        disabled && styles.containerDisabled,
        style,
      ]}
    >
      {!compact && (
        <Text
          style={[styles.label, filled && styles.labelFilled]}
          numberOfLines={1}
        >
          {label}
        </Text>
      )}
      <TouchableOpacity
        style={styles.field}
        onPress={() => setVisible(true)}
        disabled={disabled}
        activeOpacity={0.7}
        accessibilityRole="button"
        accessibilityLabel={label}
        accessibilityState={{ disabled }}
      >
        <Text
          style={[
            styles.value,
            !selectedOption && styles.placeholder,
            filled && styles.valueFilled,
          ]}
          numberOfLines={1}
        >
          {selectedOption
            ? selectedOption.label
            : compact
              ? label
              : 'Seleccionar…'}
        </Text>
        <Ionicons name="chevron-down" size={20} color={chevronColor} />
      </TouchableOpacity>
      <DropdownModal
        visible={visible}
        onClose={() => setVisible(false)}
        title={label}
        options={options}
        selectedValue={selectedValue}
        onSelect={handleSelect}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.white,
    borderRadius: borderRadius.sm,
    borderWidth: 1,
    borderColor: colors.gray[300],
    minHeight: 44,
    justifyContent: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
  },
  containerCompact: {
    borderRadius: borderRadius.full,
    minHeight: 36,
    paddingVertical: 0,
  },
  containerFilled: {
    backgroundColor: colors.primary[500],
    borderColor: colors.primary[500],
  },
  containerDisabled: {
    opacity: 0.5,
    borderColor: colors.gray[200],
  },
  label: {
    fontSize: typography.fontSize.secondary,
    color: colors.gray[500],
  },
  labelFilled: {
    color: colors.white,
  },
  field: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    minHeight: 28,
  },
  value: {
    fontSize: typography.fontSize.body,
    color: colors.gray[800],
    flex: 1,
  },
  valueFilled: {
    color: colors.white,
    fontWeight: typography.fontWeight.medium,
  },
  placeholder: {
    color: colors.gray[400],
  },
});


