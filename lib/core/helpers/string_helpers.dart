class StringHelper {
  /// Shortens a wallet address to the format: `start...end`
  static String shortenWalletAddress(String? address,
      {int start = 6, int end = 3}) {
    if (address == null || address.isEmpty || address.length <= start + end) {
      return "No Wallet";
    } else {
      return '${address.substring(0, start)}...${address.substring(address.length - end)}';
    }
  }

  /// Capitalizes the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Checks if a string is a valid wallet address (basic check)
  static bool isValidWalletAddress(String address) {
    return address.isNotEmpty &&
        address.length >= 32; // Adjust based on the blockchain
  }

  /// Trims and removes extra spaces in a string
  static String cleanSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
