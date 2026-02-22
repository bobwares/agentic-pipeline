---
name: spring-patterns
description: Java Spring Boot patterns for REST APIs, JPA entities, Spring Security, and testing. Activate when working in the services/enterprise directory.
---

# Spring Boot Patterns

## Layer Architecture

```
services/enterprise/src/main/java/com/example/
├── controller/         # REST controllers (@RestController)
├── service/            # Business logic (@Service)
├── repository/         # Data access (@Repository)
├── entity/             # JPA entities (@Entity)
├── dto/                # Java Records for request/response
├── exception/          # Custom exceptions + @RestControllerAdvice
└── config/             # Spring Security, OpenAPI, etc.
```

## Entity

```java
// entity/User.java
@Entity
@Table(name = "users", indexes = {
    @Index(name = "idx_users_email", columnList = "email", unique = true)
})
@Getter @Setter @NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role = UserRole.USER;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private Instant updatedAt;
}
```

## DTO as Java Record

```java
// dto/CreateUserRequest.java
public record CreateUserRequest(
    @NotBlank @Size(max = 100) String name,
    @NotBlank @Email String email,
    UserRole role
) {
    public CreateUserRequest {
        if (role == null) role = UserRole.USER;
    }
}

// dto/UserResponse.java
public record UserResponse(UUID id, String name, String email, UserRole role, Instant createdAt) {
    public static UserResponse from(User user) {
        return new UserResponse(user.getId(), user.getName(), user.getEmail(),
            user.getRole(), user.getCreatedAt());
    }
}
```

## Service

```java
// service/UserService.java
@Service
@RequiredArgsConstructor
@Slf4j
public class UserService {
    private final UserRepository userRepository;

    @Transactional
    public UserResponse createUser(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new ConflictException("Email already exists: " + request.email());
        }
        User user = new User();
        user.setName(request.name());
        user.setEmail(request.email());
        user.setRole(request.role());
        User saved = userRepository.save(user);
        log.info("Created user: {}", saved.getId());
        return UserResponse.from(saved);
    }

    @Transactional(readOnly = true)
    public UserResponse findById(UUID id) {
        return userRepository.findById(id)
            .map(UserResponse::from)
            .orElseThrow(() -> new ResourceNotFoundException("User not found: " + id));
    }
}
```

## Controller

```java
// controller/UserController.java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "Users", description = "User management")
public class UserController {
    private final UserService userService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Create user")
    @ApiResponse(responseCode = "201", description = "Created")
    @ApiResponse(responseCode = "409", description = "Email conflict")
    public UserResponse create(@Valid @RequestBody CreateUserRequest request) {
        return userService.createUser(request);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get user by ID")
    @ApiResponse(responseCode = "200", description = "Found")
    @ApiResponse(responseCode = "404", description = "Not found")
    public UserResponse findById(@PathVariable UUID id) {
        return userService.findById(id);
    }
}
```

## Global Exception Handler

```java
// exception/GlobalExceptionHandler.java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleNotFound(ResourceNotFoundException ex) {
        return new ErrorResponse("NOT_FOUND", ex.getMessage());
    }

    @ExceptionHandler(ConflictException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ErrorResponse handleConflict(ConflictException ex) {
        return new ErrorResponse("CONFLICT", ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorResponse handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
            .map(e -> e.getField() + ": " + e.getDefaultMessage())
            .collect(Collectors.joining(", "));
        return new ErrorResponse("VALIDATION_ERROR", message);
    }
}
```

## Anti-Patterns

- Exposing JPA entities in responses
- Business logic in controllers
- Missing `@Transactional` on mutations
- `System.out.println` — use SLF4J
- Field injection `@Autowired` — use constructor injection
