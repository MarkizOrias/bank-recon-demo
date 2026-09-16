function generateSalt() {
  return crypto.getRandomValues(new Uint8Array(16));
}

function bufferToHex(buffer) {
  return Array.from(new Uint8Array(buffer))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

async function hashPassword(password, salt) {
  const encoder = new TextEncoder();
  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    encoder.encode(password),
    "PBKDF2",
    false,
    ["deriveBits"],
  );

  const derivedBits = await crypto.subtle.deriveBits(
    { name: "PBKDF2", salt, iterations: 100000, hash: "SHA-256" },
    keyMaterial,
    256,
  );

  return bufferToHex(derivedBits);
}

const username = process.argv[2];
const password = process.argv[3];

// CLI username + pwd entry
if (!username || !password) {
  console.error("Usage: node seed-admin.mjs <username> <password>");
  process.exit(1);
}

const salt = generateSalt();
const saltHex = bufferToHex(salt);
const passwordHash = await hashPassword(password, salt);

// Generates SQL command to insert the initial admin user with pwd hash and saltHex to the Users table with: npx wrangler d1 execute recon-demo-db --remote --command "<OUTPUT>"
console.log(
  `INSERT INTO Users (username, password_hash, salt, role, active) VALUES ('${username}', '${passwordHash}', '${saltHex}', 'admin', 1);`,
);
