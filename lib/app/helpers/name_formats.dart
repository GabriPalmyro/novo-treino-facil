String capitalizeString(String fullName) {
  if (fullName.isEmpty)
  return '';
else
  return fullName[0].toUpperCase() + fullName.substring(1);
}
