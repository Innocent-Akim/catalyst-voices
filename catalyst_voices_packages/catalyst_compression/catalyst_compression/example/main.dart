import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';

final derCertHex = '''
308202343082019DA00302010202145A
FC371DAF301793CF0B1835A118C2F903
63D5D9300D06092A864886F70D01010B
05003045310B30090603550406130241
553113301106035504080C0A536F6D65
2D53746174653121301F060355040A0C
18496E7465726E657420576964676974
7320507479204C7464301E170D323430
3731313038353733365A170D32353037
31313038353733365A3045310B300906
03550406130241553113301106035504
080C0A536F6D652D5374617465312130
1F060355040A0C18496E7465726E6574
205769646769747320507479204C7464
30819F300D06092A864886F70D010101
050003818D0030818902818100CD28E2
0B157CA70C85433C1689B1D5890EC479
BDD1FFDCC5647AE12BE9BADF4AF20764
CD24BD64130831A57506DFBBDD3E924C
96B259C6CCEDF24D6A25618F0819643C
739F145B733C3C94333E5937B499ADA9
A4FFC127457C7CB557F2F5623DCADEA1
E06F09129DB9584B0AEE949244B3252B
52AFDE5D385C65E563A6EFB07F020301
0001A321301F301D0603551D0E041604
1492EB169818B833588321957A846077
AA239CF3A0300D06092A864886F70D01
010B0500038181002E5F73333CE667E4
172B252416EAA1D2E9681F59943724B4
F366A8B930443CA6B69B12DD9DEBEE9C
8A6307695EE1884DA4B00136195D1D82
23D1C253FF408EDFC8ED03AF1819244C
35D3843855FB9AF86E84FB7636FA3F4A
0FC396F6FB6FD16D3BCEBDE68A8BD81B
E61E8EE7D77E9F7F9804E03EBC31B458
1313C955A667658B
'''
    .replaceAll('\n', '');

void main() {
  final rawBytes = hex.decode(derCertHex);

  // brotli
  final brotli = CatalystCompression.instance.brotli;
  final brotliCompressed = brotli.compress(rawBytes);
  final brotliDecompressed = brotli.decompress(brotliCompressed);

  assert(
    listEquals(rawBytes, brotliDecompressed),
    'Original and decompressed bytes must be the same!',
  );

  // zstd
  final zstd = CatalystCompression.instance.zstd;
  final zstdCompressed = zstd.compress(rawBytes);
  final zstdDecompressed = zstd.decompress(zstdCompressed);

  assert(
    listEquals(rawBytes, zstdDecompressed),
    'Original and decompressed bytes must be the same!',
  );
}
