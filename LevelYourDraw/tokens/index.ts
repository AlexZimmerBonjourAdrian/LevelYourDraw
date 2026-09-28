export const colors = {
  white: '#FFFFFF',
  gray: {
    50: '#F9FAFB',
    100: '#F3F4F6',
    200: '#E5E7EB',
    300: '#D1D5DB',
    400: '#9CA3AF',
    500: '#6B7280',
    600: '#4B5563',
    700: '#374151',
    800: '#1F2937',
  },
  primary: {
    50: '#EEF2FF',
    500: '#4F46E5',
    600: '#4338CA',
    700: '#3730A3',
    800: '#312E81',
    border: '#4F46E5',
  },
  semantic: {
    error: { bg: '#FEF2F2', border: '#FECACA', solid: '#DC2626', text: '#991B1B' },
    success: { bg: '#F0FDF4', border: '#BBF7D0', solid: '#16A34A', text: '#166534' },
    warning: { bg: '#FFFBEB', border: '#FDE68A', solid: '#D97706', text: '#92400E' },
  },
};
export const typography = {
  fontSize: { body: 15, chip: 12, footnote: 12, secondary: 14, sectionHeader: 13 },
  fontWeight: { regular: '400' as const, medium: '500' as const, semiBold: '600' as const, bold: '700' as const },
  letterSpacing: { sectionHeader: 0.5 },
  lineHeight: { body: 20 },
};
export const spacing = { xs: 4, sm: 8, md: 12, lg: 16, xl: 24, safeAreaBottom: 16, sectionHeader: 12 };
export const borderRadius = { sm: 8, md: 12, lg: 16, xl: 20, full: 999 };
export const shadows = {
  primaryButton: { elevation: 2 },
  sheet: { elevation: 4 },
};
