# ErfanApp Modules

This directory contains the modular architecture for ErfanApp, organized into separate Swift packages.

## Module Structure

### BaseModule
Location: `Modules/BaseModule/`

The **BaseModule** provides foundational functionality for the entire app:
- Core protocols and configurations
- Shared utilities and helpers
- Base classes and structures

**Features:**
- `Base` struct for basic operations
- `BaseConfiguration` protocol for app configuration
- `DefaultConfiguration` implementation

### ServiceModule
Location: `Modules/ServiceModule/`

The **ServiceModule** provides the service layer functionality:
- Depends on the BaseModule
- Business logic and data services
- Firebase integration (Auth, Firestore, Storage, Analytics)

**Features:**
- `Service` struct that uses BaseModule configuration
- `ServiceProtocol` for dependency injection
- `DataService` example implementation
- Complete Firebase services (Auth, Firestore, Storage)
- `FirebaseServiceFactory` for easy service creation

## Dependencies

```
ErfanApp (Main App)
    ├── BaseModule (Foundation)
    └── ServiceModule (Business Logic + Firebase)
            └── BaseModule (Dependency)
```

## Adding Modules to Xcode

To add these modules to your Xcode project:

1. Open your Xcode project
2. Select the project in the navigator
3. Select your app target
4. Go to "General" tab
5. Scroll to "Frameworks, Libraries, and Embedded Content"
6. Click the "+" button
7. Click "Add Other" → "Add Package Dependency"
8. Choose "Add Local..." and navigate to:
   - `Modules/BaseModule` for the BaseModule
   - `Modules/ServiceModule` for the ServiceModule
9. Select the products you want to add

Alternatively, in the project navigator:
- File → Add Package Dependencies → Add Local
- Select the module directories

## Testing

Each module has its own test suite:
- BaseModule tests: `Modules/BaseModule/Tests/BaseModuleTests/`
- ServiceModule tests: `Modules/ServiceModule/Tests/ServiceModuleTests/`

Run tests using:
```bash
# Test BaseModule
cd Modules/BaseModule
swift test

# Test ServiceModule
cd Modules/ServiceModule
swift test
```

## Development

When developing, you can work on modules independently:
- Each module is a complete Swift package
- Changes are reflected immediately in the main app
- Modules can be tested in isolation
- Clear separation of concerns

## Benefits of This Architecture

1. **Modularity**: Code is organized into logical, reusable components
2. **Testability**: Each module can be tested independently
3. **Maintainability**: Clear boundaries between different parts of the app
4. **Scalability**: Easy to add new modules as the app grows
5. **Reusability**: Modules can be shared across projects

