import fs from "fs/promises";
import path from "path";

const GITHUB_WORKSPACE = process.env.GITHUB_WORKSPACE;
const {default: generate} = await import(path.join(GITHUB_WORKSPACE, ".github/gen-manifest.js"));

const ENVIRONMENT = process.env.ENVIRONMENT;

const MANIFEST_PATH = path.join(GITHUB_WORKSPACE, "manifest.json");

await fs.copyFile(MANIFEST_PATH, path.join(GITHUB_WORKSPACE, ".manifest.json.bak"));

const manifestFile = await fs.readFile(MANIFEST_PATH, "utf8");
const manifest = generate(ENVIRONMENT, JSON.parse(manifestFile));

await fs.writeFile(MANIFEST_PATH, JSON.stringify(manifest), "utf8");