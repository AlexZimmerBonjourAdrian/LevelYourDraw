import React from 'react';
import {
  Modal,
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Dimensions,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, typography, spacing, borderRadius } from '../tokens';

interface DropdownOption {
  label: string;
  value: string | number | undefined;
}

interface DropdownModalProps {
  visible: boolean;
  onClose: () => void;
  title: string;
  options: DropdownOption[];
  selectedValue?: string | number | undefined;
  onSelect: (value: string | number | undefined) => void;
}

const { width: SCREEN_WIDTH } = Dimensions.get('window');

export default function DropdownModal({
  visible,
  onClose,
  title,
  options,
  selectedValue,
  onSelect,
}: DropdownModalProps) {
  const handleSelect = (value: string | number | undefined) => {
    onSelect(value);
    onClose();
  };

  const handleOverlayPress = () => {
    onClose();
  };

  return (
    <Modal
      visible={visible}
      transparent
      animationType="fade"
      onRequestClose={onClose}
    >
      <TouchableOpacity
        style={styles.overlay}
        activeOpacity={1}
        onPress={handleOverlayPress}
      >
        <View style={styles.dropdownContainer}>
          <View style={styles.dropdown}>
            <View style={styles.dropdownHeader}>
              <Text style={styles.title}>{title}</Text>
              <TouchableOpacity onPress={onClose} style={styles.closeButton}>
                <Ionicons name="close" size={20} color={colors.gray[400]} />
              </TouchableOpacity>
            </View>
            <ScrollView
              style={styles.optionsList}
              keyboardShouldPersistTaps="handled"
            >
              {options.map((option) => {
                const isSelected = selectedValue === option.value;
                return (
                  <TouchableOpacity
                    key={option.label}
                    style={[styles.option, isSelected && styles.optionSelected]}
                    onPress={() => handleSelect(option.value)}
                    activeOpacity={0.7}
                  >
                    <Text
                      style={[
                        styles.optionText,
                        isSelected && styles.optionTextSelected,
                      ]}
                    >
                      {option.label}
                    </Text>
                    {isSelected && (
                      <Ionicons
                        name="checkmark"
                        size={20}
                        color={colors.primary[500]}
                        style={styles.checkmark}
                      />
                    )}
                  </TouchableOpacity>
                );
              })}
            </ScrollView>
          </View>
        </View>
      </TouchableOpacity>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.4)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  dropdownContainer: {
    width: SCREEN_WIDTH - 48,
    paddingHorizontal: spacing.lg,
  },
  dropdown: {
    backgroundColor: colors.white,
    borderRadius: borderRadius.lg,
    maxHeight: 320,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.2,
    shadowRadius: 16,
    elevation: 12,
  },
  dropdownHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.md,
    paddingBottom: spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: colors.gray[200],
  },
  title: {
    fontSize: typography.fontSize.secondary,
    fontWeight: typography.fontWeight.bold,
    color: colors.gray[600],
    letterSpacing: typography.letterSpacing.sectionHeader,
  },
  closeButton: {
    padding: spacing.xs,
  },
  optionsList: {
    maxHeight: 260,
  },
  option: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.lg,
    borderBottomWidth: 1,
    borderBottomColor: colors.gray[100],
    minHeight: 48,
  },
  optionSelected: {
    backgroundColor: colors.primary[50],
  },
  optionText: {
    fontSize: typography.fontSize.body,
    color: colors.gray[800],
    flex: 1,
  },
  optionTextSelected: {
    fontWeight: typography.fontWeight.semiBold,
    color: colors.primary[800],
  },
  checkmark: {
    marginLeft: spacing.md,
  },
});

