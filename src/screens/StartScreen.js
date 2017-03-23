import React, {Component} from 'react'
import { 
  ListView, 
  StyleSheet, 
  TouchableHighlight, 
  View, 
  Text, 
  Image, 
  Dimensions, 
  Platform, 
  NativeModules, 
  NativeEventEmitter 
} from 'react-native'

const PESDK = NativeModules.PESDK
const RNFS = require('react-native-fs')

export default class PESDKDemo extends Component {
  constructor (props) {
    super(props)

    var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2})
    this.state = {
      dataSource: ds.cloneWithRows(this._rows(this._generateItems())),
      output: 'Select an image to edit...'
    }
  }

  _generateItems () {
    let items = []
    for (var i = 0; i < 100; i++) {
      items.push({
        index: i
      })
    }

    return items
  }

  _rows (items) {
    var rows = []
    var row = []
    items.forEach((item) => {
      if (row.length === 3) {
        rows.push(row)
        row = [item]
      } else {
        row.push(item)
      }
    })

    if (row.length > 0) {
      rows.push(row)
    }

    return rows
  }

// --------------------------------------------------------------- RENDERING

  _renderRow (row) {
    var { width } = Dimensions.get('window')
    var sideLength = width / 3

    var items = []
    row.forEach((item) => {
      let uri = 'https://unsplash.it/200/200?image=' + item.index
      items.push((
        <TouchableHighlight style={{ width: sideLength, height: sideLength }} key={item.index} onPress={this._onItemPressed.bind(this, item)}>
          <Image
            style={styles.thumb}
            source={{ uri: uri }}
          />
        </TouchableHighlight>
      ))
    })

    return (
      <View style={styles.row}>
        {items}
      </View>
    )
  }

  render () {
    let showStatus = this.state.output !== undefined
    return (
      <View>
        { showStatus && <Text style={styles.status}>{this.state.output}</Text> }
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this._renderRow.bind(this)}
        />
      </View>
    )
  }

  // --------------------------------------------------------------- EVENTS

  _onItemPressed (item) {
    const progress = data => {
      const percentage = ((100 * data.bytesWritten) / data.contentLength) | 0
      const text = `Downloading Image... ${percentage}%`
      this.setState({ output: text })
    }

    this.setState({ output: 'Starting image download...' })
    const imageUrl = 'https://unsplash.it/2048/2048?image=' + item.index
    const imagePath = RNFS.DocumentDirectoryPath + '/image.jpeg'
    this.setState({ downloading: true })
    RNFS.downloadFile({ fromUrl: imageUrl, toFile: imagePath, progress: progress }).promise.then(result => {
      PESDK.present(imagePath)
      this.setState({ output: 'Select an image to edit...' })
    })
  }

  componentWillMount() {
    this.eventEmitter = new NativeEventEmitter(NativeModules.PESDK);
    this.eventEmitter.addListener('PhotoEditorDidCancel', () => {
      // The photo editor was cancelled.
    })
    this.eventEmitter.addListener('PhotoEditorDidSave', (body) => {
      // The body contains the edited image in JPEG and NSData representation and
      // one could further process it from here. 
    })
    this.eventEmitter.addListener('PhotoEditorDidFailToGeneratePhoto', () => {
      // The photo editor could not create a photo.
    })
  }

  componentWillUnmount() {
    this.eventEmitter.removeAllListeners('PhotoEditorDidCancel')
    this.eventEmitter.removeAllListeners('PhotoEditorDidSave')
    this.eventEmitter.removeAllListeners('PhotoEditorDidFailToGeneratePhoto')
  }
}

// --------------------------------------------------------------- STYLES

var styles = StyleSheet.create({
  status: {
    padding: 8,
    fontSize: 12,
    textAlign: 'center',
    backgroundColor: '#edeeef'
  },
  list: {
    justifyContent: 'center',
    flexDirection: 'row',
    flexWrap: 'wrap'
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden'
  },
  thumb: {
    width: '100%',
    height: '100%'
  }
})
