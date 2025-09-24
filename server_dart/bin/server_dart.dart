import 'package:grpc/grpc.dart';
import 'package:server_dart/server_dart.dart';

Future<void> main(List<String> args) async {
  final server = Server.create(
    services: [ChatService()],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: 8080);
  print('Server listening on port ${server.port}...');
}
