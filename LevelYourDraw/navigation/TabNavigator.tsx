import React from 'react';
import { Text, View } from 'react-native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { useBriefAleatorio } from '../features/HomeFeature';
import Button from '../components/Button';
import Card from '../components/Card';
import type { MainTabParamList } from './types';

const Tab = createBottomTabNavigator<MainTabParamList>();

function InicioTab() {
  const { brief, generar } = useBriefAleatorio();
  return (
    <View style={{ flex: 1, padding: 16, gap: 12 }}>
      <Card>
        <Text>{brief.titulo}</Text>
        <Text>{brief.consigna}</Text>
      </Card>
      <Button onPress={generar}>Nuevo brief</Button>
    </View>
  );
}

function GaleriaTab() {
  return (
    <View style={{ flex: 1, padding: 16 }}>
      <Text>Galeria de retos guardados.</Text>
    </View>
  );
}

function AjustesTab() {
  return (
    <View style={{ flex: 1, padding: 16 }}>
      <Text>Preferencias locales del dispositivo.</Text>
    </View>
  );
}

export function TabNavigator() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Inicio" component={InicioTab} />
      <Tab.Screen name="Galeria" component={GaleriaTab} />
      <Tab.Screen name="Ajustes" component={AjustesTab} />
    </Tab.Navigator>
  );
}
