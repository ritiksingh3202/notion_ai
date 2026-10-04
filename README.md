# Notion Clone

A collaborative document workspace built with Next.js, Clerk authentication, Firebase, and a complementary Cloudflare Worker.

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Available Scripts](#available-scripts)
- [API / Endpoints](#api--endpoints)
- [Testing](#testing)
- [Deployment](#deployment)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

## Features
- **Authentication:** Integrated server-side and client-side protection via Clerk.
- **Database mutations:** Next.js Server Actions handle secure operations, such as provisioning new documents and assigning user ownership roles.
- **Data Layer:** Cloud Firestore integration using both Firebase Admin (server) and Firebase Client (browser) SDKs.
- **Styling:** Tailwind CSS combined with Radix UI / Shadcn UI components for a modern, accessible interface.
- **Edge Compute:** Included Cloudflare Worker scaffolding for deploying globally distributed, low-latency API routes.

## Tech Stack

| Layer | Technology |
|---|---|
| **Frontend Framework** | Next.js 15 (App Router), React 19 |
| **Styling** | Tailwind CSS, class-variance-authority, clsx, tailwind-merge |
| **UI Components** | Radix UI, lucide-react |
| **Authentication** | Clerk (`@clerk/nextjs`) |
| **Database / BaaS** | Firebase (Client SDK), Firebase Admin (Server SDK) |
| **Edge Compute** | Cloudflare Workers |
| **Language** | TypeScript |
| **Testing** | Vitest (for Cloudflare Workers) |

## Architecture
The system is divided into two primary services:
1. **Next.js Web Application:** Utilizes the App Router and React Server Components. Client components consume the Firebase Client SDK to read and listen to data. Secure operations (like creating new documents and updating room relationships) occur within Server Actions, strictly executed using the Firebase Admin SDK. Authentication is protected globally via Clerk middleware.
2. **Cloudflare Worker:** A serverless edge function intended for lightweight, complementary API processing. It currently serves simple diagnostic routes and provides a foundation for extending the application to the edge.

## Project Structure

```text
.
├── notion-clone/                                # Next.js frontend application
│   ├── actions/                                 # Server Actions (e.g., actions.ts)
│   ├── app/                                     # App router pages, layouts, and global styles
│   ├── components/                              # Shared UI components and Shadcn primitives
│   ├── lib/                                     # Utility functions (e.g., utils.ts)
│   ├── types/                                   # TypeScript type definitions
│   ├── firebase.ts                              # Firebase Client initialization
│   ├── firebase-admin.ts                        # Firebase Admin SDK initialization
│   ├── middleware.ts                            # Clerk authentication middleware
│   └── service_key.json                         # Firebase Admin credentials (local only)
└── notion-clone-cloudflare-workers/             # Edge computing services
    └── rapid-glade-6b9a/                        # Cloudflare Worker project
        ├── src/                                 # Worker entry point and route handlers
        ├── test/                                 # Vitest test suites
        └── wrangler.jsonc                       # Cloudflare Worker configuration
```

## Getting Started

### Prerequisites
- Node.js (>= 20)

### Installation
Clone the repository and install dependencies for both services:

```bash
git clone https://github.com/ritiksingh3202/notion_ai.git
cd notion_ai

# Install Next.js dependencies
cd notion-clone
npm install

# Install Cloudflare Worker dependencies
cd ../notion-clone-cloudflare-workers/rapid-glade-6b9a
npm install
```

### Running Locally
To run both development servers concurrently, open two terminal windows:

**Terminal 1 (Next.js Application):**
```bash
cd notion-clone
npm run dev
```

**Terminal 2 (Cloudflare Worker):**
```bash
cd notion-clone-cloudflare-workers/rapid-glade-6b9a
npm run dev
```

## Environment Variables

| Name | Description | Example | Required |
|---|---|---|---|
| `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` | Clerk public key for client auth | `pk_test_...` | Yes |
| `CLERK_SECRET_KEY` | Clerk secret key for server verification | `sk_test_...` | Yes |

*Note: The Firebase Admin SDK currently relies on a `service_key.json` file placed in the `notion-clone` root. The Firebase Client configuration is hardcoded in `firebase.ts`.*

## Available Scripts

### Next.js (`notion-clone/package.json`)
| Script | Command | Purpose |
|---|---|---|
| `dev` | `next dev` | Starts the Next.js development server |
| `build` | `next build` | Builds the application for production |
| `start` | `next start` | Starts the production server |
| `lint` | `eslint` | Runs ESLint to check for code issues |

### Cloudflare Worker (`rapid-glade-6b9a/package.json`)
| Script | Command | Purpose |
|---|---|---|
| `dev` / `start` | `wrangler dev` | Starts local worker development server |
| `deploy` | `wrangler deploy` | Deploys the worker to Cloudflare edge |
| `test` | `vitest` | Runs the Vitest test suite |
| `cf-typegen` | `wrangler types` | Generates TypeScript types for Cloudflare environment |

## API / Endpoints

### Next.js Server Actions
Located in `notion-clone/actions/actions.ts`:
- `createNewDocument()`
  - **Purpose:** Authenticates the incoming request, creates a new document entry in the `documents` Firestore collection, and creates an associated room reference in `users/{email}/rooms/{roomId}` with an `owner` role.
  - **Returns:** `{ docId: string }` on success, or `{ docId: '', error: string }` on failure.

### Cloudflare Worker Endpoints
Located in `rapid-glade-6b9a/src/index.ts`:
- `GET /message`
  - **Purpose:** Diagnostic route.
  - **Returns:** Plain text `Hello, World!`.
- `GET /random`
  - **Purpose:** Diagnostic route demonstrating crypto API.
  - **Returns:** A randomly generated UUID string.

## Testing
- **Cloudflare Worker:** Test suites are run using Vitest. Execute `npm run test` from within the worker directory.
- **Next.js App:** A test suite is not currently configured for the frontend application.

## Deployment
- **Next.js:** Designed to be deployed via Vercel. Standard build command (`npm run build`) applies. Ensure environment variables and Firebase Admin credentials are securely configured in your deployment platform.
- **Cloudflare Worker:** Deploy directly to Cloudflare by running `npm run deploy` from the worker directory.

## Roadmap
- [ ] Migrate hardcoded Firebase client credentials (`firebase.ts`) to environment variables.
- [ ] Integrate a rich text collaborative editor (e.g., BlockNote, TipTap).
- [ ] Expand Cloudflare Worker functionality to offload heavy API processing.
- [ ] Add a comprehensive testing suite (Jest/Playwright) for the Next.js frontend.

## Contributing
1. Fork the project.
2. Create your feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes adhering to Conventional Commits standards.
4. Run `npm run lint` and ensure there are no errors before opening a Pull Request.
5. Push to the branch and submit a PR.

## License
MIT

## Author
Ritik Singh (https://github.com/ritiksingh3202)
