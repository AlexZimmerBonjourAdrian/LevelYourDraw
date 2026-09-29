import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { InicioScreen } from '../screens/InicioScreen';
import { GaleriaScreen } from '../screens/GaleriaScreen';
import { CapturaScreen } from '../screens/CapturaScreen';
import { AjustesScreen } from '../screens/AjustesScreen';
import type { MainTabParamList } from './types';

const Tab = createBottomTabNavigator<MainTabParamList>();

export function TabNavigator() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Inicio" component={InicioScreen} />
      <Tab.Screen name="Galeria" component={GaleriaScreen} />
      <Tab.Screen name="Captura" component={CapturaScreen} />
      <Tab.Screen name="Ajustes" component={AjustesScreen} />
    </Tab.Navigator>
  );
}
