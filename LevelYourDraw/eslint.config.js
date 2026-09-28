const { defineConfig } = require('eslint/config');
const expoConfig = require('eslint-config-expo/flat');
const eslintPluginPrettierRecommended = require('eslint-plugin-prettier/recommended');

module.exports = defineConfig([
  {
    ignores: ['dist/*', 'node_modules/*', '.expo/*'],
  },
  expoConfig,
  eslintPluginPrettierRecommended,
  {
    rules: {
      'import/namespace': 'off',
      'import/no-unresolved': 'off',
      'import/no-duplicates': 'off',
    },
  },
]);
