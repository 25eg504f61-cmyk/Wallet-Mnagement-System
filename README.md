# Full-Stack Digital Wallet System

An enterprise-grade, secure digital wallet application featuring a **Spring Boot** backend and a **React** frontend. It implements robust financial architecture, including a Double-Entry Ledger, Idempotent transactions to prevent double-charging, and JWT Authentication.

---

### Individual Contribution Breakdown

| Contributor | Role | Core Deliverables & Responsibilities |
| :--- | :--- | :--- |
| **Mansi** | Lead Full-Stack Architect | • Architected Double-Entry Bookkeeping Ledger System <br> • Implemented Redis Header-based Idempotency Interceptors <br> • Designed Pessimistic Concurrency Locking logic in Spring Boot <br> • Developed Interactive React Dashboard with Tailwind & Framer Motion <br> • Handled end-to-end Database Schema, API Integration & Debugging |
| **Team Member** | Team Member | • *No code or architectural contributions delivered for this release.* |

> **Note:** All backend business logic, database configurations, state management, and frontend interactive components were individually authored and verified by Mansi.

---

## 🌟 Key Features

- **Double-Entry Ledger**: Implemented inside `WalletService` using transactional SQL locking to guarantee that money is never created or destroyed, only credited and debited.
- **Dashboard Ledger Aggregation**: "Total Sent" and "Total Received" statistics are calculated on the backend via PostgreSQL JPQL queries for 100% accuracy.
- **Idempotency (Double-Charge Prevention)**: The backend physically rejects duplicate transfer attempts caused by network drops by validating a unique `Idempotency-Key` at the PostgreSQL schema level.
- **Role-Based Authentication**: Secure JWT-based auth separating standard Users from Admins.
- **Modern FinTech Dashboard**: A premium, CRED/Revolut inspired dark-mode UI with glassmorphism, dynamic Framer Motion micro-interactions, and real-time balance charts using `Recharts`.
- **Digital Receipt Modal**: Verifiable transaction receipts featuring simulated QR codes, Blockchain Hash IDs, and a PDF download option.
- **Split Bill Widget**: Interactive dashboard tool to calculate bill splits instantly and generate secure request links.
- **Security Badges**: Real-time visual trust indicators emphasizing high-security idempotency protection during transfers.
- **Pessimistic Locking**: Prevents race conditions and deadlocks when executing concurrent transfers between wallets.

---

## 🛠 Tech Stack

**Backend**
- Java 17 / Spring Boot 3
- Spring Security (JWT)
- Spring Data JPA
- PostgreSQL
- Maven

**Frontend**
- React 18
- Vite
- Tailwind CSS (FinTech Design System & Glassmorphism)
- Framer Motion (Micro-interactions & Animations)
- Lucide React (Iconography)
- Recharts (Data Visualization)
- React Router DOM
- Axios

---

## 📂 Project Structure

```text
wallet-system/
├── frontend/             # React Application
│   ├── src/
│   │   ├── api/          # Axios instance & interceptors
│   │   ├── components/   # Reusable UI components
│   │   ├── context/      # React Context (Auth)
│   │   ├── pages/        # Dashboard, Wallet, Transfer, History
│   │   └── styles/       # CSS Design System
│   └── package.json
│
├── backend/              # Spring Boot Backend
│   ├── src/
│   │   └── main/java/com/mansi/wallet_system/
│   │       ├── controller/   # REST Endpoints
│   │       ├── service/      # Business Logic (Ledger, Transfers)
│   │       ├── repository/   # JPA Repositories
│   │       ├── entity/       # Database Models
│   │       └── security/     # JWT Filters & Config
│   ├── pom.xml           # Maven Dependencies
│   └── Dockerfile        # Backend Container
│
└── docker-compose.yml    # Infrastructure
```

---

## 🚀 Getting Started

### 1. Database Setup (MySQL 8.0)
The system is configured for MySQL 8.0 on port `3306`.
- **Option A: Local MySQL Service**
  - Make sure your local MySQL service is running on port `3306`.
  - Spring Boot auto-creates the database and tables (`ddl-auto=update`, `createDatabaseIfNotExist=true`).
  - To initialize manually, execute `backend/src/main/resources/schema-mysql.sql` in MySQL Workbench or CLI:
    ```bash
    mysql -u root -p < backend/src/main/resources/schema-mysql.sql
    ```
- **Option B: Docker Compose**
  ```bash
  docker compose up -d mysql redis
  ```

### 2. Start the Backend (Spring Boot)
Using the runner script:
```powershell
.\run-backend.ps1 -DbPassword <your_mysql_password>
```
Or manually:
```powershell
cd backend
$env:DB_PASSWORD = "<your_mysql_password>"
.\mvnw.cmd spring-boot:run
```
*The API will be available at `http://localhost:8082`*

### 3. Start the Frontend (React + Vite)
Using the runner script:
```powershell
.\run-frontend.ps1
```
Or manually:
```powershell
cd frontend
npm.cmd run dev
```
*The UI will be available at `http://localhost:5173`*

---

### 4. Default Demo Accounts

Upon first startup, the backend automatically seeds the following test accounts:

| Role | Name | Email | Password | Initial Balance |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | Admin | `admin@wallet.com` | `Admin@123` | \$5,000.00 |
| **User** | John Doe | `user@wallet.com` | `Password@123` | \$1,000.00 |
| **User (Recipient)** | Alex Smith | `alex@wallet.com` | `Password@123` | \$500.00 |

*(You can also click **"Create one now"** on the login page to register a new account anytime).*

---

## 📚 API Documentation (Swagger)

Once the backend is running, you can explore and test the API endpoints using the interactive Swagger UI:
👉 **[http://localhost:8082/swagger-ui/index.html](http://localhost:8082/swagger-ui/index.html)**

---

## 🔒 Security & Architecture Notes

- **Password Hashing**: User passwords are encrypted using BCrypt before hitting the database.
- **Idempotency Keys**: For every transfer, the React frontend generates a `crypto.randomUUID()`. The Spring Boot backend checks the `transactions` table (which has a `@Column(unique=true)` constraint on `idempotency_key`) to ensure that a retried network request never results in a double deduction.
- **ACID Compliance**: All monetary operations in `WalletService` are annotated with `@Transactional`. If any part of the double-entry process fails, the entire transaction rolls back instantly.

---

## 👤 Author

**Backend Developer & Lead:** Mansi Gupta