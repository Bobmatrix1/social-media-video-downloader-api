const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      name: 'Admin',
      isAdmin: true,
    },
  });

  const apiKey = await prisma.apiKey.upsert({
    where: { key: 'dk_1234567890abcdef1234567890abcdef' },
    update: {},
    create: {
      key: 'dk_1234567890abcdef1234567890abcdef',
      name: 'Default Key',
      userId: user.id,
      rateLimit: 1000,
      maxDuration: 3600,
    },
  });

  console.log('Seed data created:');
  console.log('User:', user);
  console.log('API Key:', apiKey);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
