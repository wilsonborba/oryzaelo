# Oryza-Elo (Frontend Monorepo)

Multi-App Flutter frontend for precision agriculture phenological monitoring and agro-meteorological intelligence, operating both on offline edge hardware (Raspberry Pi) and in the Asodya Cloud.

---

## 1. Monorepo Architecture

```
oryzaelo/
├── apps/
│   ├── local/                 # Offline-first responsive web app for rural growers (served by edge engine)
│   └── cloud/                 # (Stage 2) Executive multi-farm portal & academic research showcase
├── common/
│   └── oryzaelo_ui/           # Shared Design System, BBCH scales, telemetry charts, trilingual i18n
├── cliff.toml                 # Conventional Commits changelog configuration
├── analysis_options.yaml      # Static analysis and lint rules
└── pubspec.yaml               # Dart workspace definition
```

### IP Protection & Separation of Concerns
- **`apps/local`**: Distributable offline on edge hardware (port 8005 via `ServeDir` in `oryzaelo_engine`). Zero cloud SaaS logic or proprietary endpoints compiled in the bundle.
- **`apps/cloud`**: Cloud multi-tenant portal and public thesis benchmark dashboard.
- **`common/oryzaelo_ui`**: Shared UI primitives, typed domain models, and trilingual translation dictionaries (`pt-BR`, `en`, `th`).

---

## 2. Development Setup

Requires Flutter `>=3.41` and Dart `>=3.11` with workspace support enabled.

```bash
# Resolve dependencies across all workspace packages
flutter pub get

# Run static analysis
flutter analyze

# Run tests
flutter test apps/local/test common/oryzaelo_ui/test
```

---

## 3. Building for Edge Deployment

```bash
cd apps/local
flutter build web --release
```

Point `STATIC_DIR` in `oryzaelo_engine/.env` to `oryzaelo/apps/local/build/web` to serve the application offline on the Raspberry Pi.
