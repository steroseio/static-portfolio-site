import sharp from 'sharp';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.join(__dirname, '..');
const svgPath = path.join(root, 'public', 'favicon.svg');

const targets = [
  { file: 'favicon-96x96.png', size: 96 },
  { file: 'apple-touch-icon.png', size: 180 },
  { file: 'icon-192x192.png', size: 192 },
  { file: 'icon-512x512.png', size: 512 }
];

async function buildRasterIcons() {
  await Promise.all(
    targets.map(({ file, size }) =>
      sharp(svgPath)
        .resize(size, size, { fit: 'cover' })
        .png({ compressionLevel: 9 })
        .toFile(path.join(root, 'public', file))
    )
  );
}

async function buildIco() {
  const pngBuffer = await sharp(svgPath)
    .resize(64, 64, { fit: 'cover' })
    .png({ compressionLevel: 9 })
    .toBuffer();

  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0); // reserved
  header.writeUInt16LE(1, 2); // image type (icon)
  header.writeUInt16LE(1, 4); // number of images

  const entry = Buffer.alloc(16);
  entry.writeUInt8(64, 0); // width
  entry.writeUInt8(64, 1); // height
  entry.writeUInt8(0, 2); // color palette
  entry.writeUInt8(0, 3); // reserved
  entry.writeUInt16LE(1, 4); // color planes
  entry.writeUInt16LE(32, 6); // bits per pixel
  entry.writeUInt32LE(pngBuffer.length, 8); // size of image data
  entry.writeUInt32LE(header.length + entry.length, 12); // offset

  const icoBuffer = Buffer.concat([header, entry, pngBuffer]);
  fs.writeFileSync(path.join(root, 'public', 'favicon.ico'), icoBuffer);
}

async function run() {
  await buildRasterIcons();
  await buildIco();
  console.log('Generated PNG and ICO favicons from favicon.svg');
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
