class TokenData {
  final int decimals;
  final int editionNonce;
  final bool fungible;
  final bool isMutable;
  final String key;
  final String metadataAddress;
  final String mintAddress;
  final String name;
  final bool native;
  final bool primarySaleHappened;
  final String programAddress;
  final String symbol;
  final String tokenStandard;
  final String updateAuthority;
  final String uri;
  final String postBalance;

  TokenData({
    required this.decimals,
    required this.editionNonce,
    required this.fungible,
    required this.isMutable,
    required this.key,
    required this.metadataAddress,
    required this.mintAddress,
    required this.name,
    required this.native,
    required this.primarySaleHappened,
    required this.programAddress,
    required this.symbol,
    required this.tokenStandard,
    required this.updateAuthority,
    required this.uri,
    required this.postBalance,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      decimals: json['Decimals'] ?? 0,
      editionNonce: json['EditionNonce'] ?? 0,
      fungible: json['Fungible'] ?? false,
      isMutable: json['IsMutable'] ?? false,
      key: json['Key'] ?? "",
      metadataAddress: json['MetadataAddress'] ?? "",
      mintAddress: json['MintAddress'] ?? "",
      name: json['Name'] ?? "",
      native: json['Native'] ?? false,
      primarySaleHappened: json['PrimarySaleHappened'] ?? false,
      programAddress: json['ProgramAddress'] ?? "",
      symbol: json['Symbol'] ?? "",
      tokenStandard: json['TokenStandard'] ?? "",
      updateAuthority: json['UpdateAuthority'] ?? "",
      uri: json['Uri'] ?? "",
      postBalance: json['PostBalance'] ?? "0",
    );
  }

  Map<String, dynamic> toJson() => {
        'decimals': decimals,
        'editionNonce': editionNonce,
        'fungible': fungible,
        'isMutable': isMutable,
        'key': key,
        'metadataAddress': metadataAddress,
        'mintAddress': mintAddress,
        'name': name,
        'native': native,
        'primarySaleHappened': primarySaleHappened,
        'programAddress': programAddress,
        'symbol': symbol,
        'tokenStandard': tokenStandard,
        'updateAuthority': updateAuthority,
        'uri': uri,
        'postBalance': postBalance,
      };
}
