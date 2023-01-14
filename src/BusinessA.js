import React from 'react';
import {View, Text, SafeAreaView, StyleSheet, Image} from 'react-native';

export default function BusinessA() {
  return (
    <SafeAreaView>
      <View style={styles.container}>
        <Image style={styles.image} source={require('./assets/a.jpeg')} />
        <Text style={styles.text}>BusinessA</Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: 209.5,
    height: 300,
  },
  text: {
    marginTop: 10,
  },
});
