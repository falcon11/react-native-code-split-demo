/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 *
 * @format
 */

const fs = require('fs');

const idListPath = './bundle/idList.json';
const nextIdPath = './bundle/nextId.txt';

if (fs.existsSync(idListPath)) {
  fs.rmSync(idListPath);
}
fs.writeFileSync(idListPath, '{}', 'utf-8');

if (fs.existsSync(nextIdPath)) {
  fs.rmSync(nextIdPath);
}

const projectRootPath = __dirname;
let curModuleId = 1;

function createModuleId(path) {
  return curModuleId++;
}

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
        let idListStr = fs.readFileSync(idListPath, {encoding: 'utf-8'});
        let idList;
        if (idListStr.length === 0) {
          idList = {};
        } else {
          idList = JSON.parse(idListStr);
        }
        if (idList[modulePath]) return idList[modulePath];
        const moduleId = createModuleId(path) + '';
        // fs.appendFileSync('./idList.txt', `${moduleId}\n`);
        idList[modulePath] = moduleId;
        idListStr = JSON.stringify(idList);
        fs.writeFileSync(idListPath, idListStr, {encoding: 'utf-8'});
        fs.writeFileSync(nextIdPath, moduleId, 'utf-8');
        return moduleId;
      };
      // return function (path) {
      //   // 根据文件的相对路径构建 ModuleId
      //   const projectRootPath = __dirname;
      //   let moduleId = path.substr(projectRootPath.length + 1);

      //   // 把 moduleId 写入 idList.txt 文件，记录公有模块 id
      //   fs.appendFileSync('./idList.txt', `${moduleId}\n`);
      //   return moduleId;
      // };
    },
  },
};
