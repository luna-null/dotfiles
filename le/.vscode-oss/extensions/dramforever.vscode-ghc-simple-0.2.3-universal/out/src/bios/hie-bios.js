"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCradleConfig = void 0;
const fs = require("fs");
const path = require("path");
const yaml = require("js-yaml");
function getCradleConfig(workspaceUri) {
    return __awaiter(this, void 0, void 0, function* () {
        const hieYamlPath = path.join(workspaceUri.fsPath, 'hie.yaml');
        const contents = yield new Promise((resolve, reject) => {
            fs.readFile(hieYamlPath, 'utf-8', (err, data) => {
                if (err)
                    reject(err);
                else
                    resolve(data);
            });
        });
        return yaml.load(contents);
    });
}
exports.getCradleConfig = getCradleConfig;
//# sourceMappingURL=hie-bios.js.map