import {Navigation} from 'react-native-navigation'

import {registerScreens} from './screens'
registerScreens()

Navigation.startSingleScreenApp({
  screen: {
    screen: 'pesdkdemo.StartScreen',
    title: 'PESDK Demo',
    navigatorStyle: {
      navBarBackgroundColor: '#ffffff',
      navBarTextColor: '#be4385',
      navBarSubtitleTextColor: '#ff0000',
      navBarButtonColor: '#ffffff',
      statusBarTextColorScheme: 'dark',
      statusBarHideWithNavBar: true
    }
  }
})
