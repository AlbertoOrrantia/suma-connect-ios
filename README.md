# 📱 Suma Connect Client (iOS)

[![SwiftUI](https://img.shields.io/badge/SwiftUI-43B02A?style=for-the-badge&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![iOS](https://img.shields.io/badge/iOS-16.0%2B-000000?style=for-the-badge&logo=apple)](https://developer.apple.com/ios/)
[![Networking](https://img.shields.io/badge/Networking-URLSession-F05138?style=for-the-badge&logo=apple)](https://developer.apple.com/documentation/foundation/urlsession)

Hello, I'm **Alberto Orrantia**, the lead developer for the **Suma Connect** integration service.

This repository contains the **iOS mobile client** for the Minimum Viable Product (MVP). Built with **SwiftUI** and following the **MVVM (Model-View-ViewModel)** pattern, this application consumes the RESTful services from the Vapor backend to handle the authentication flow and display available integrations.

> ⚠️ This client is tightly coupled to the Suma Connect Vapor backend (v1.0.0).  
> API contracts are expected to evolve in V2.

> 📦 Current Stable Release: **v1.0.0**

---

## 🌟 Highlights

* **100% Swift Stack:** Unified language stack with the Vapor backend.
* **Declarative UI:** Built entirely using SwiftUI for a modern and maintainable user interface.
* **Modern Concurrency:** Leverages Swift's native `async/await` for all API calls via URLSession.
* **Component-Based Design:** Clean architecture with clear separation of layers (`Core`, `Features`, `DesignSystem`).

## ⬇️ Installation and Setup

### Prerequisites & Dependencies

| Requirement | Minimal Specs | Recommended (Developer System) | Dependencies |
| :--- | :--- | :--- | :--- |
| **Xcode** | Xcode 14+ | **Xcode 26.1** | N/A |
| **Swift** | Swift 5.7+ | **Swift 6.2+** | N/A |
| **Operating System** | macOS 13+ | **macOS Tahoe** | N/A |
| **Minimum Deployment Target** | **iOS 16.0** | N/A | N/A |

### Quick Start (Cloning & Running)

The application requires the Vapor backend to be running locally on the same network.

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/AlbertoOrrantia/SumaConnect
    ```
2.  **Open the Project:**
    ```bash
    open SumaConnect.xcodeproj
    ```
3.  **Backend Setup:** Ensure the Vapor backend is running locally on your machine (default port `8080`).

4.  **🚨 Critical Base URL Adjustment for Physical Devices:**
    * If testing on a physical iPhone, the Simulator's `127.0.0.1` will not work.
    * **You must update** the `baseURL` in `Core/Networking/IntegrationAPI.swift` to your machine's **local IP address**.

    ```swift
    // In Core/Networking/IntegrationAPI.swift
    private let baseURL = "http://YOUR_LOCAL_IP:8080/api/v1" 
    // Example: "http://192.168.0.40:8080/api/v1"
    ```

5.  **Run Client:** Select your target device (Simulator or Physical) and press **Command + R** (or the Play button).

---

## ⚙️ Minimum Supported Version Rationale (iOS 16.0)

We have set **iOS 16.0** as the minimum supported version to achieve the best balance between code quality and global market share.

1.  **SwiftUI & Concurrency Stability:** While SwiftUI became usable with iOS 13, critical frameworks like `URLSession` and native `async/await` reached full stability in iOS 15. Targeting **iOS 16** offers a solid foundation, capitalizing on performance improvements and setting the stage for future adoption of the `Observation` framework (V2 Roadmap).
2.  **Global Market Share:** As of July 2025, iOS 16 and higher versions cover approximately **~93.1%** of all active devices (Source: iosref.com). This decision ensures excellent market penetration while leveraging modern API optimizations.

---

## 💻 Architecture and Folder Structure

The project uses the **MVVM** pattern with a clear separation of concerns, facilitating team collaboration and scaling.

| Folder | Role | Key Contents |
| :--- | :--- | :--- |
| **Application** | Entry Point | Application lifecycle (`SumaConnectApp.swift`), Main Tab Bar (`MainTabView`). |
| **Core** | Shared Business Logic | `Models`, `Networking` (API, Clients, Errors), `Services` (Integration logic), `Session` (Auth State Management). |
| **DesignSystem** | Reusable UI | `Components` (Buttons, Headers), `Colors` (Brand definitions), `Fonts`. |
| **Features** | Screen Modules | Contains all Vistas (`Views`) and their corresponding `ViewModels` separated by feature (`Login`, `Home`, `Chat`, `Settings`). |

## 🎨 Design and Asset Conventions

This section documents explicit design and asset decisions made during the MVP development phase:

### Color Palette and UI Decisions

* **Centralized Color System:** All brand colors (`SumaRed`, `SumaLightBlue`, etc.) are centralized and defined programmatically in `DesignSystem/Colors/Color+Suma.swift`. **Decision:** This ensures global consistency and allows for easy future migration to dynamic colors for Dark Mode.
* **Deprecation Trade-off (`foregroundColor`):** The current codebase relies on the older `.foregroundColor()` modifier. **Decision:** This syntax was accepted as a time-saving measure during the MVP phase. **Future work (V2 Roadmap) must migrate this to the modern `.foregroundStyle()`** to ensure code longevity and compatibility.

### Asset Management Decisions

* **Minimalist Assets:** Only icon assets are included (App Icon, third-party service icons like `google.png`).
* **Trade-off (No Photo Assets):** **No complex photo assets or background images** were included in the MVP. **Decision:** This avoids potential legal and technical issues related to licensing, copyrights, and maintaining a minimal build size.

## 🧪 Testing Strategy (V1.0.0 Trade-offs)

Due to MVP timelines and necessary development trade-offs, test coverage for the V1.0.0 release was limited:

* **Manual/Integration Testing:** Primary testing relied exclusively on manual UI validation and console logging to confirm network flows and view rendering.
* **Unit/UI Testing (Deferred):** Establishing full Unit and UI test coverage was explicitly deferred to the **V2 Roadmap**. Future development must prioritize implementing comprehensive tests across all layers (Networking, Services, ViewModels) to prevent regression.

## 🌱 Branching Strategy

This repository utilizes the same professional flow based on **Git Feature Branching** as the backend project.

### Branch Structure

| Branch Name | Role | Purpose |
| :--- | :--- | :--- |
| **main** | Stable/Production | Contains tagged, stable release versions (v1.0.0, v1.1.0...). |
| **development** | Integration/Active | The active branch for continuous integration and testing. |
| **feature/\*** | Work-in-Progress | Branches for single modules, features, or fixes (e.g., `feature/dark-mode`, `fix/login-bug`). |

### Workflow

1.  **Create:** Create a new branch (e.g., `feature/module-name`) from `development`.
2.  **Commit:** Implement changes with incremental commits.
3.  **Review:** Open a Pull Request (PR) when complete.
4.  **Merge:** Merge the PR into `development`.
5.  **Release:** When a version is complete, merge `development` into `main` and create a corresponding Git Tag (e.g., `v1.1.0`).

---

## 🛣️ Future Roadmap (V2.0.0 Goals)

This is the **V1.0.0** foundation. The next major version (V2.0.0) will focus on application maturity and UI polish:

* **Dark Mode Support:** Implement dynamic color variables to fully support the iOS system Dark/Light themes.
* **Migration to `Observation`:** Update ViewModels from `ObservableObject` to the newer `Observation` framework for enhanced SwiftUI performance.
* **Full Authentication Flow:** Integrate the complete registration/login process with the final backend security model.

## 🏷️ Versioning

This project strictly adheres to **Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`**.

* **MAJOR (X.0.0):** Breaking changes, API incompatibilities (e.g., V1.0.0 -> V2.0.0).
* **MINOR (0.X.0):** Addition of new, backward-compatible features.
* **PATCH (0.0.X):** Small, backward-compatible bug fixes.

## 💬 Feedback and Contribution

We encourage feedback on the SwiftUI architecture and interface design. If you have suggestions or encounter an issue, please open an Issue or start a Discussion.
