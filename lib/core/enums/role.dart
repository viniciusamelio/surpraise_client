enum Role {
  member("member", "Membro", 1),
  moderator("moderator", "Moderador", 2),
  admin("owner", "Admin", 3);

  const Role(this.value, this.display, this.level);

  final String value;
  final String display;
  final int level;

  factory Role.fromString(String value) =>
      values.firstWhere((element) => element.value == value);
}
