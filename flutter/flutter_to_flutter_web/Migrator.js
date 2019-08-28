var ncp = require('ncp').ncp
const config = require('./config.json')

ncp.limit = 16

class Migrator {
  constructor (fromNative) {
    this.fromNative = fromNative || true
    if (this.fromNative) {
      this.srcDir = 'native'
      this.destDir = 'web'
    } else {
      this.srcDir = 'web'
      this.destDir = 'native'
    }
  }

  migrate () {
    ncp(
      `../${this.srcDir}/lib/`,
      `../${this.destDir}/lib`,
      {
        filter: this.filter.bind(this),
        transform: this.transform,
        stopOnErr: true
      },
      function (err) {
        if (err) {
          return console.error(err)
        }
        console.log('Done!')
      }
    )
  }

  filter (fileName) {
    console.log(`Migrating ${fileName}...`)
    for (var exclusionRule of config.exclude) {
      const regex = new RegExp(
        `.*/flutter/${this.srcDir}${exclusionRule}.*`,
        'g'
      )
      if (fileName.match(regex)) {
        console.log('File ignored.')
        return false
      }
    }
    return true
  }

  transform (read, write) {
    read.on('readable', function () {
      let chunk
      while ((chunk = read.read()) !== null) {
        chunk = chunk
          .toString()
          .replace(/package:flutter\//g, 'package:flutter_web/')
        write.write(chunk)
      }
    })
  }
}

module.exports = Migrator
