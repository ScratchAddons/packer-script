import fs from "fs/promises";
import path from "path";

const GITHUB_WORKSPACE = process.env.GITHUB_WORKSPACE;
const {default: generate} = await import(path.join(GITHUB_WORKSPACE, ".github/gen-manifest.mjs"));

const ENVIRONMENT = process.env.ENVIRONMENT;

const MANIFEST_PATH = path.join(GITHUB_WORKSPACE, "manifest.json");

await fs.copyFile(MANIFEST_PATH, path.join(GITHUB_WORKSPACE, ".manifest.json.bak"));

const manifestFile = await fs.readFile(MANIFEST_PATH, "utf8");
console.log("Generating JSON for: ", ENVIRONMENT);
const manifest = generate(ENVIRONMENT, JSON.parse(manifestFile));
console.log("Manifest created at: ", MANIFEST_PATH);
console.dir(manifest);

await fs.writeFile(MANIFEST_PATH, JSON.stringify(manifest), "utf8");