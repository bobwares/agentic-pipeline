---
name: testing-patterns
description: Testing patterns for Vitest (unit/integration) and Playwright (E2E). Includes factory functions, mocking patterns, and TDD workflow. Activate when writing or fixing tests.
---

# Testing Patterns

## Vitest Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
    setupFiles: ['./tests/setup.ts'],
    coverage: {
      provider: 'v8',
      thresholds: { lines: 80, functions: 80 },
      exclude: ['**/node_modules/**', '**/dist/**', '**/*.config.*'],
    },
  },
  resolve: {
    alias: { '@': path.resolve(__dirname, './src') },
  },
});
```

## Factory Pattern

```typescript
// tests/factories/user.factory.ts
import { User } from '@/packages/database/schema';

let counter = 0;

export function getMockUser(overrides?: Partial<User>): User {
  counter++;
  return {
    id: `user-${counter}-${Date.now()}`,
    name: `Test User ${counter}`,
    email: `user-${counter}@test.com`,
    role: 'user',
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides,
  };
}
```

## Service Unit Test

```typescript
// users.service.spec.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UsersService } from './users.service';

describe('UsersService', () => {
  let service: UsersService;
  let mockDb: ReturnType<typeof createMockDb>;

  beforeEach(() => {
    vi.clearAllMocks();
    mockDb = createMockDb();
    service = new UsersService(mockDb);
  });

  describe('create', () => {
    it('creates and returns a user', async () => {
      const dto = { name: 'Alice', email: 'alice@test.com' };
      const expected = getMockUser(dto);
      mockDb.insert.mockResolvedValue([expected]);

      const result = await service.create(dto);

      expect(result).toEqual(expected);
      expect(mockDb.insert).toHaveBeenCalledWith(users);
    });

    it('throws ConflictException on duplicate email', async () => {
      const dto = { name: 'Alice', email: 'alice@test.com' };
      mockDb.insert.mockRejectedValue(new Error('unique constraint'));

      await expect(service.create(dto)).rejects.toThrow(ConflictException);
    });
  });
});
```

## Playwright E2E Test

```typescript
// e2e/users.spec.ts
import { test, expect } from '@playwright/test';

test.describe('User Management', () => {
  test('creates a user via the form', async ({ page }) => {
    await page.goto('/users/new');
    await page.getByLabel('Name').fill('Alice');
    await page.getByLabel('Email').fill('alice@test.com');
    await page.getByRole('button', { name: 'Create User' }).click();

    await expect(page).toHaveURL('/users');
    await expect(page.getByText('Alice')).toBeVisible();
  });

  test('shows empty state when no users exist', async ({ page }) => {
    await page.goto('/users');
    await expect(page.getByText('No users yet')).toBeVisible();
  });
});
```

## TDD Workflow

```
1. Write a failing test that describes the behavior
2. Run: pnpm test --run <test-file>
3. Confirm it fails with the expected reason
4. Implement the minimum code to make it pass
5. Run tests again — confirm green
6. Refactor if needed, keeping tests green
```

## Coverage Commands

```bash
pnpm test --run                    # Run all tests once
pnpm test --watch                  # Watch mode
pnpm test --coverage               # With coverage report
pnpm test --run users.service.spec # Specific file
pnpm test --run --reporter=verbose # Verbose output
```

## Anti-Patterns

- Testing implementation details (private methods, internal state)
- Deleting tests to fix coverage
- Snapshot tests for rapidly changing UI
- Shared mutable state between tests (always `beforeEach` reset)
- Tests that call real external services (mock everything external)
