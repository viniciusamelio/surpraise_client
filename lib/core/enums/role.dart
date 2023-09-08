enum Role {
  member("member", "Membro"),
  moderator("moderator", "Moderador"),
  admin("owner", "Admin");

  const Role(this.value, this.display);

  final String value;
  final String display;

  factory Role.fromString(String value) =>
      values.firstWhere((element) => element.value == value);
}
