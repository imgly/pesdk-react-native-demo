/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import type {Node} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  TouchableHighlight
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import {PESDK, Configuration} from 'react-native-photoeditorsdk';

/**
 * Uncomment the following single line of code to unlock PhotoEditor SDK automatically
 * for both platforms. Every platform requires a separate license file which must be
 * named `pesdk_license.ios.json` for the iOS license and `pesdk_license.android.json`
 * for the Android license file.
 */
// PESDK.unlockWithLicense(require('./pesdk_license'));

const Section = ({children, title}): Node => {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  );
};

const App: () => Node = () => {
  const openEditor = () => {
    // Set up sample image
    let image = require('./assets/LA.jpg');
    // Set up configuration
    let configuration: Configuration = {
      // Configure sticker tool
      sticker: {
        // Enable personal stickers
        personalStickers: true,
        // Configure sticker library
        categories: [
          // Create sticker category with stickers
          {
            identifier: 'example_sticker_category_logos',
            name: 'Logos',
            thumbnailURI: require('./assets/React.png'),
            items: [
              {
                identifier: 'example_sticker_logos_react',
                name: 'React',
                stickerURI: require('./assets/React.png'),
              },
              {
                identifier: 'example_sticker_logos_imgly',
                name: 'IMG.LY',
                stickerURI: require('./assets/Igor.png'),
              },
            ],
          },
          // Use existing sticker category
          {identifier: 'imgly_sticker_category_emoticons'},
          // Modify existing sticker category
          {
            identifier: 'imgly_sticker_category_shapes',
            items: [
              {identifier: 'imgly_sticker_shapes_badge_01'},
              {identifier: 'imgly_sticker_shapes_arrow_02'},
              {identifier: 'imgly_sticker_shapes_spray_03'},
            ],
          },
        ],
      },
    };
    PESDK.openEditor(image, configuration).then(
      (result) => {
        console.log(result);
      },
      (error) => {
        console.log(error);
      },
    );
  };
  
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Section title="PhotoEditor SDK">
            <TouchableHighlight onPress={openEditor}>
              <Text 
                style={[
                  styles.sectionDescription,
                  {
                    color: isDarkMode ? Colors.white : Colors.black,
                  },
                ]}>
                Click here to <Text style={styles.highlight}>edit a sample image</Text>.
              </Text>
            </TouchableHighlight>
          </Section>
          <Section title="Step One">
            Edit <Text style={styles.highlight}>App.js</Text> to change this
            screen and then come back to see your edits.
          </Section>
          <Section title="See Your Changes">
            <ReloadInstructions />
          </Section>
          <Section title="Debug">
            <DebugInstructions />
          </Section>
          <Section title="Learn More">
            Read the docs to discover what to do next:
          </Section>
          <LearnMoreLinks />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
