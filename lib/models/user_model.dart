class User {
  final int id;
  final String username;
  final String name;
  final String firstName;
  final String lastName;
  final String email;
  final String url;
  final String description;
  final String link;
  final String locale;
  final String nickname;
  final String slug;
  final List<String> roles;
  final String registeredDate;
  final Map<String, dynamic> capabilities;
  final Map<String, dynamic> extraCapabilities;
  final Map<String, String> avatarUrls;
  final Map<String, dynamic> meta;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.url,
    required this.description,
    required this.link,
    required this.locale,
    required this.nickname,
    required this.slug,
    required this.roles,
    required this.registeredDate,
    required this.capabilities,
    required this.extraCapabilities,
    required this.avatarUrls,
    required this.meta,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      url: json['url'],
      description: json['description'],
      link: json['link'],
      locale: json['locale'],
      nickname: json['nickname'],
      slug: json['slug'],
      roles: List<String>.from(json['roles']),
      registeredDate: json['registered_date'],
      capabilities: Map<String, dynamic>.from(json['capabilities']),
      extraCapabilities: Map<String, dynamic>.from(json['extra_capabilities']),
      avatarUrls: Map<String, String>.from(json['avatar_urls']),
      meta: Map<String, dynamic>.from(json['meta']),
    );
  }
}
