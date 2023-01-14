/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 *
 * @format
 */

const fs = require('fs');

const projectRootPath = __dirname;
const idListPath = './bundle/idList.json';
const nextIdPath = './bundle/nextId.txt';
const idList = JSON.parse(fs.readFileSync(idListPath, 'utf-8'));
let curModuleId = parseInt(fs.readFileSync(nextIdPath, 'utf-8'), 10);
// Object.values(idList).forEach(item => {
//   const itemId = parseInt(item, 10);
//   curModuleId = Math.max(itemId, curModuleId);
// });
curModuleId++;
let bussinessIdList = {};

module.exports = {
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
  serializer: {
    createModuleIdFactory: function () {
      return path => {
        const modulePath = path.substr(projectRootPath.length + 1);
        if (idList[modulePath]) return idList[modulePath];
        if (bussinessIdList[modulePath]) return bussinessIdList[modulePath];
        const moduleId = `${curModuleId++}`;
        bussinessIdList[modulePath] = moduleId;
        fs.writeFileSync(nextIdPath, `${moduleId}`, 'utf-8');
        return `${moduleId}`;
      };
    },
    processModuleFilter: function (modules) {
      const modulePath = modules.path.substr(projectRootPath.length + 1);
      if (idList[modulePath]) {
        return false;
      }
      return true;
    },
  },
};
