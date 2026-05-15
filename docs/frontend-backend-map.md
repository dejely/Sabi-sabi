# Sabi-Sabi Frontend ↔ Backend File Map

This document maps the planned Sabi-Sabi frontend files to their matching backend files, API routes, database tables, and feature responsibilities.

> Suggested location in the repo: `docs/frontend-backend-map.md`

---

## 1. Purpose

Sabi-Sabi is a bulletin-board style web app where users can browse public boards/notes, create their own boards and notes, reply through threaded messages, post anonymously, use tags, and support admin moderation.

This map helps developers know:

- which frontend page/component calls which backend module,
- which backend route handles the request,
- which database table is affected,
- and where to place new files when implementing a feature.

---

## 2. Recommended High-Level Repo Structure

```txt
Sabi-sabi/
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── assets/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── styles/
│   │   ├── main.js
│   │   └── router.js
│   ├── index.html
│   ├── package.json
│   └── .env.example
│
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── middleware/
│   │   ├── modules/
│   │   ├── routes/
│   │   ├── app.js
│   │   └── server.js
│   ├── package.json
│   └── .env.example
│
├── database/
│   ├── migrations/
│   ├── seed/
│   └── schema.sql
│
├── docs/
│   ├── architecture.md
│   ├── api-spec.md
│   ├── database-schema.md
│   └── frontend-backend-map.md
│
├── README.md
└── .gitignore
```

---

## 3. Frontend to Backend Feature Map

| Feature | Frontend Files | Backend Files | Main API Routes | Database Tables | Usage |
|---|---|---|---|---|---|
| App entry | `frontend/src/main.js` | `backend/src/server.js`, `backend/src/app.js` | N/A | N/A | Starts frontend app and backend server. |
| Routing | `frontend/src/router.js` | `backend/src/routes/index.js` | N/A | N/A | Frontend route navigation and backend route grouping. |
| API client | `frontend/src/services/api.js` | All backend route files | All `/api/*` routes | All tables | Central place for `fetch()` or Axios calls. |
| Authentication | `frontend/src/pages/LoginPage.js`, `RegisterPage.js` | `backend/src/modules/auth/` | `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me` | `users` | Handles registration, login, password hashing, and session/JWT checks. |
| Public home feed | `frontend/src/pages/HomePage.js` | `backend/src/modules/boards/`, `backend/src/modules/notes/` | `GET /api/boards/public`, `GET /api/notes/public` | `board`, `note` | Lets guests browse public boards and notes. |
| User dashboard | `frontend/src/pages/DashboardPage.js` | `backend/src/modules/users/`, `boards/`, `notes/` | `GET /api/users/me/boards`, `GET /api/users/me/notes` | `users`, `board`, `note` | Shows the logged-in user's own content. |
| Board management | `frontend/src/pages/BoardPage.js`, `components/board/*` | `backend/src/modules/boards/` | `GET /api/boards/:id`, `POST /api/boards`, `PATCH /api/boards/:id`, `DELETE /api/boards/:id` | `board`, `access`, `board_tag` | Create, view, edit, delete, or soft-remove boards. |
| Note management | `frontend/src/pages/NotePage.js`, `components/note/*` | `backend/src/modules/notes/` | `GET /api/notes/:id`, `POST /api/boards/:boardId/notes`, `PATCH /api/notes/:id`, `DELETE /api/notes/:id` | `note`, `board` | Create and manage notes under boards. |
| Threaded messages | `frontend/src/components/message/*` | `backend/src/modules/messages/` | `GET /api/messages?boardId=`, `GET /api/messages?noteId=`, `POST /api/messages`, `PATCH /api/messages/:id`, `DELETE /api/messages/:id` | `message` | Supports comments and nested replies using `parent_message_id`. |
| Anonymous posting | `frontend/src/components/message/AnonymousToggle.js`, note/message forms | `backend/src/modules/messages/`, `backend/src/modules/notes/` | Same note/message create routes | `message`, `note`, `users` | Hides public identity but keeps internal user ID for moderation. |
| Tags | `frontend/src/components/board/TagSelector.js` | `backend/src/modules/tags/` | `GET /api/tags`, `POST /api/tags`, `POST /api/boards/:id/tags` | `tag`, `board_tag` | Adds searchable tags to boards. |
| Search and filters | `frontend/src/pages/SearchPage.js`, `components/search/*` | `backend/src/modules/search/` | `GET /api/search?q=&tag=&date=&sort=` | `board`, `note`, `message`, `tag`, `board_tag` | Searches by keyword, tag, date posted, recent activity, or content similarity. |
| Access control | `frontend/src/components/access/*` | `backend/src/modules/access/`, `middleware/roleMiddleware.js` | `GET /api/boards/:id/access`, `POST /api/boards/:id/access`, `PATCH /api/access/:id`, `DELETE /api/access/:id` | `access`, `users`, `board` | Manages owner/editor/viewer permissions on private boards. |
| Moderation | `frontend/src/pages/AdminPage.js`, `components/moderation/*` | `backend/src/modules/moderation/` | `GET /api/moderation/queue`, `PATCH /api/moderation/:type/:id/status` | `board`, `note`, `message` | Admin review, approve, close, remove, and restore content. |
| Error handling | `frontend/src/components/ui/ErrorMessage.js` | `backend/src/middleware/errorHandler.js` | All routes | N/A | Shows graceful errors for failed requests. |
| Loading states | `frontend/src/components/ui/LoadingSpinner.js` | N/A | N/A | N/A | Shows user feedback while fetching API data. |

---

## 4. Suggested Frontend Structure and Usage

```txt
frontend/src/
├── assets/
│   └── logo.svg
├── components/
│   ├── layout/
│   │   ├── Navbar.js
│   │   ├── Footer.js
│   │   └── PageContainer.js
│   ├── board/
│   │   ├── BoardCard.js
│   │   ├── BoardForm.js
│   │   ├── BoardVisibilityBadge.js
│   │   └── TagSelector.js
│   ├── note/
│   │   ├── NoteCard.js
│   │   └── NoteForm.js
│   ├── message/
│   │   ├── MessageThread.js
│   │   ├── MessageItem.js
│   │   ├── MessageForm.js
│   │   └── AnonymousToggle.js
│   ├── search/
│   │   ├── SearchBar.js
│   │   └── FilterPanel.js
│   ├── moderation/
│   │   ├── ModerationQueue.js
│   │   └── StatusActionButtons.js
│   └── ui/
│       ├── Button.js
│       ├── Input.js
│       ├── Modal.js
│       ├── LoadingSpinner.js
│       └── ErrorMessage.js
├── pages/
│   ├── HomePage.js
│   ├── LoginPage.js
│   ├── RegisterPage.js
│   ├── DashboardPage.js
│   ├── BoardPage.js
│   ├── NotePage.js
│   ├── SearchPage.js
│   └── AdminPage.js
├── services/
│   ├── api.js
│   ├── authService.js
│   ├── boardService.js
│   ├── noteService.js
│   ├── messageService.js
│   ├── tagService.js
│   └── moderationService.js
├── styles/
│   ├── base.css
│   ├── layout.css
│   └── components.css
├── main.js
└── router.js
```

### Frontend file roles

| File/Folder | Purpose |
|---|---|
| `main.js` | Frontend entry point. Mounts the app. |
| `router.js` | Defines frontend pages and route guards. |
| `services/api.js` | Central API client. Stores base URL and request helper. |
| `services/*Service.js` | Feature-specific API functions. Keeps pages cleaner. |
| `pages/` | Full pages/screens. Should not contain too much API logic. |
| `components/` | Reusable UI parts used by pages. |
| `components/ui/` | Generic UI components like buttons, inputs, modals, loaders. |
| `styles/` | Shared CSS files. |

---

## 5. Suggested Backend Structure and Usage

```txt
backend/src/
├── config/
│   └── db.js
├── middleware/
│   ├── authMiddleware.js
│   ├── roleMiddleware.js
│   ├── validateRequest.js
│   └── errorHandler.js
├── modules/
│   ├── auth/
│   │   ├── auth.routes.js
│   │   ├── auth.controller.js
│   │   └── auth.service.js
│   ├── users/
│   │   ├── user.routes.js
│   │   ├── user.controller.js
│   │   └── user.service.js
│   ├── boards/
│   │   ├── board.routes.js
│   │   ├── board.controller.js
│   │   └── board.service.js
│   ├── notes/
│   │   ├── note.routes.js
│   │   ├── note.controller.js
│   │   └── note.service.js
│   ├── messages/
│   │   ├── message.routes.js
│   │   ├── message.controller.js
│   │   └── message.service.js
│   ├── tags/
│   │   ├── tag.routes.js
│   │   ├── tag.controller.js
│   │   └── tag.service.js
│   ├── access/
│   │   ├── access.routes.js
│   │   ├── access.controller.js
│   │   └── access.service.js
│   ├── search/
│   │   ├── search.routes.js
│   │   ├── search.controller.js
│   │   └── search.service.js
│   └── moderation/
│       ├── moderation.routes.js
│       ├── moderation.controller.js
│       └── moderation.service.js
├── routes/
│   └── index.js
├── app.js
└── server.js
```

### Backend file roles

| File/Folder | Purpose |
|---|---|
| `server.js` | Starts the backend server and listens on a port. |
| `app.js` | Configures Express middleware and route mounting. |
| `routes/index.js` | Combines all route modules under `/api`. |
| `config/db.js` | Database connection pool/client. |
| `middleware/authMiddleware.js` | Checks if a user is logged in. |
| `middleware/roleMiddleware.js` | Checks owner/editor/viewer/admin permissions. |
| `middleware/validateRequest.js` | Validates request body/query params. |
| `middleware/errorHandler.js` | Handles API errors consistently. |
| `modules/*/*.routes.js` | Defines URL endpoints. |
| `modules/*/*.controller.js` | Handles request/response logic. |
| `modules/*/*.service.js` | Contains business logic and database queries. |

---

## 6. API Route Map

### Authentication

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `POST` | `/api/auth/register` | `authService.register()` | `auth.controller.js` | Create account. |
| `POST` | `/api/auth/login` | `authService.login()` | `auth.controller.js` | Login user. |
| `POST` | `/api/auth/logout` | `authService.logout()` | `auth.controller.js` | Logout user. |
| `GET` | `/api/auth/me` | `authService.getCurrentUser()` | `auth.controller.js` | Check active user session. |

### Boards

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/boards/public` | `boardService.getPublicBoards()` | `board.controller.js` | Fetch public boards for guests/users. |
| `GET` | `/api/boards/:id` | `boardService.getBoard(id)` | `board.controller.js` | Fetch one board. |
| `POST` | `/api/boards` | `boardService.createBoard(data)` | `board.controller.js` | Create board. |
| `PATCH` | `/api/boards/:id` | `boardService.updateBoard(id, data)` | `board.controller.js` | Edit board. |
| `DELETE` | `/api/boards/:id` | `boardService.deleteBoard(id)` | `board.controller.js` | Soft-delete/remove board. |

### Notes

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/notes/public` | `noteService.getPublicNotes()` | `note.controller.js` | Fetch public notes. |
| `GET` | `/api/notes/:id` | `noteService.getNote(id)` | `note.controller.js` | Fetch one note. |
| `POST` | `/api/boards/:boardId/notes` | `noteService.createNote(boardId, data)` | `note.controller.js` | Create note under board. |
| `PATCH` | `/api/notes/:id` | `noteService.updateNote(id, data)` | `note.controller.js` | Edit note. |
| `DELETE` | `/api/notes/:id` | `noteService.deleteNote(id)` | `note.controller.js` | Soft-delete/remove note. |

### Messages / Threads

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/messages?boardId=:id` | `messageService.getBoardMessages(boardId)` | `message.controller.js` | Get board discussion threads. |
| `GET` | `/api/messages?noteId=:id` | `messageService.getNoteMessages(noteId)` | `message.controller.js` | Get note discussion threads. |
| `POST` | `/api/messages` | `messageService.createMessage(data)` | `message.controller.js` | Create top-level message or reply. |
| `PATCH` | `/api/messages/:id` | `messageService.updateMessage(id, data)` | `message.controller.js` | Edit message. |
| `DELETE` | `/api/messages/:id` | `messageService.deleteMessage(id)` | `message.controller.js` | Soft-delete/remove message. |

### Tags

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/tags` | `tagService.getTags()` | `tag.controller.js` | Fetch all tags. |
| `POST` | `/api/tags` | `tagService.createTag(data)` | `tag.controller.js` | Create tag. |
| `POST` | `/api/boards/:id/tags` | `tagService.attachTags(boardId, tags)` | `tag.controller.js` | Add tags to board. |

### Access Control

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/boards/:id/access` | `accessService.getBoardAccess(boardId)` | `access.controller.js` | View board access list. |
| `POST` | `/api/boards/:id/access` | `accessService.grantAccess(boardId, data)` | `access.controller.js` | Add user access. |
| `PATCH` | `/api/access/:id` | `accessService.updateAccess(id, data)` | `access.controller.js` | Change role. |
| `DELETE` | `/api/access/:id` | `accessService.removeAccess(id)` | `access.controller.js` | Remove access. |

### Search

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/search?q=&tag=&sort=&date=` | `searchService.search(params)` | `search.controller.js` | Search boards, notes, messages, and tags. |

### Moderation

| Method | Route | Frontend caller | Backend handler | Purpose |
|---|---|---|---|---|
| `GET` | `/api/moderation/queue` | `moderationService.getQueue()` | `moderation.controller.js` | Get pending/flagged content. |
| `PATCH` | `/api/moderation/:type/:id/status` | `moderationService.updateStatus(type, id, status)` | `moderation.controller.js` | Approve, close, remove, or restore content. |

---

## 7. Database Table Map

| Table | Used by Backend Module | Used by Frontend Feature |
|---|---|---|
| `users` | `auth`, `users`, `access`, `moderation` | Login, register, dashboard, access management. |
| `board` | `boards`, `search`, `moderation`, `access` | Public board list, board detail, dashboard, admin page. |
| `note` | `notes`, `search`, `moderation` | Notes under boards, note detail, dashboard. |
| `message` | `messages`, `search`, `moderation` | Threaded comments and replies. |
| `tag` | `tags`, `search` | Tag selector and search filters. |
| `board_tag` | `tags`, `boards`, `search` | Linking tags to boards. |
| `access` | `access`, `boards`, `middleware/roleMiddleware.js` | Private board sharing and role permissions. |

---

## 8. Feature Implementation Order

Follow this order so the frontend and backend do not block each other too much.

### Step 1: Foundation

1. Move Vite frontend files into `frontend/`.
2. Create `backend/` Express app.
3. Create `database/schema.sql` and migration files.
4. Add `.env.example` files.
5. Add `docs/frontend-backend-map.md`.

### Step 2: Auth and Database

1. Create `users` table.
2. Create register/login backend routes.
3. Create login/register frontend pages.
4. Add auth middleware.

### Step 3: Boards and Notes

1. Create `board` and `note` tables.
2. Create board CRUD API.
3. Create note CRUD API.
4. Create board and note frontend pages.

### Step 4: Messages and Threads

1. Create `message` table with nullable `parent_message_id`.
2. Add message API.
3. Add message thread frontend components.
4. Add lazy loading for replies if needed.

### Step 5: Tags, Search, and Access

1. Create `tag`, `board_tag`, and `access` tables.
2. Add tag APIs.
3. Add search APIs.
4. Add role-based access middleware.
5. Add frontend tag selector and search filter UI.

### Step 6: Moderation and Polish

1. Add status update APIs.
2. Add admin moderation dashboard.
3. Add error/loading/empty states.
4. Add responsive UI improvements.
5. Add final testing checklist.

---

## 9. Development Rule of Thumb

When adding a new feature, create files in this pattern:

```txt
frontend/src/pages/FeaturePage.js
frontend/src/components/feature/FeatureComponent.js
frontend/src/services/featureService.js

backend/src/modules/feature/feature.routes.js
backend/src/modules/feature/feature.controller.js
backend/src/modules/feature/feature.service.js

database/migrations/00X_create_feature_table.sql
docs/api-spec.md update
docs/frontend-backend-map.md update
```

Example for `boards`:

```txt
frontend/src/pages/BoardPage.js
frontend/src/components/board/BoardCard.js
frontend/src/components/board/BoardForm.js
frontend/src/services/boardService.js

backend/src/modules/boards/board.routes.js
backend/src/modules/boards/board.controller.js
backend/src/modules/boards/board.service.js

database/migrations/002_create_boards.sql
```

---

## 10. Notes for Sabi-Sabi Stability

- Keep frontend pages thin. Put API calls in `services/`.
- Keep backend routes thin. Put business logic in `service.js` files.
- Use `status = 'removed'` for soft deletion instead of immediately deleting rows.
- Use `parent_message_id = NULL` for top-level messages.
- Use `parent_message_id = <message_id>` for replies.
- Never expose the real user identity of anonymous posts to normal users.
- Only admins/moderators should see internal identity for moderation.
- Validate all request data before writing to the database.
- Hash passwords before saving users.
- Add indexes for search-heavy fields such as dates, tags, status, and visibility.

---

## 11. Minimum Pull Request Checklist

Before merging a feature PR, check:

- [ ] Frontend page/component exists if the feature is user-facing.
- [ ] Backend route/controller/service exists if the feature needs data.
- [ ] Database migration exists if the feature needs schema changes.
- [ ] `.env.example` updated if new environment variables are needed.
- [ ] README or docs updated.
- [ ] Manual test steps are written in the PR.
- [ ] No real secrets or passwords committed.
- [ ] Anonymous posts do not expose real identity publicly.
- [ ] Private board access is enforced on the backend, not only on the frontend.
