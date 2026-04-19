/// Shape returned by POST api/auth/login and POST api/auth/register.
class AuthResponseDto {
  final String token;
  final String userId;
  final String email;
  final String portfolioId;

  const AuthResponseDto({
    required this.token,
    required this.userId,
    required this.email,
    required this.portfolioId,
  });

  /// Handles both camelCase (Flutter convention) and PascalCase (.NET default).
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) => AuthResponseDto(
        token: (json['token'] ?? json['Token'] ?? '') as String,
        userId: (json['userId'] ?? json['UserId'] ?? '') as String,
        email: (json['email'] ?? json['Email'] ?? '') as String,
        portfolioId: (json['portfolioId'] ?? json['PortfolioId'] ?? '') as String,
      );
}
