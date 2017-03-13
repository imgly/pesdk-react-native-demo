import {Navigation} from 'react-native-navigation'

import StartScreen from './StartScreen'

export function registerScreens () {
  Navigation.registerComponent('pesdkdemo.StartScreen', () => StartScreen)
}
