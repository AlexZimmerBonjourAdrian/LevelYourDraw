import type { NavigatorScreenParams } from '@react-navigation/native';

export type RootStackParamList = {
  MainTabs: NavigatorScreenParams<MainTabParamList>;
  DetalleBrief: { briefId: string };
};

export type MainTabParamList = {
  Inicio: undefined;
  Galeria: undefined;
  Captura: undefined;
  Ajustes: undefined;
};

