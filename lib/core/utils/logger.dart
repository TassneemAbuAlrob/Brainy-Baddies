import 'package:logger/logger.dart';

final Logger logger = Logger();

pinfo<T>(T message){
  logger.i(message);
}

perror<T>(T message){
  logger.e(message);
}

pwarnings<T>(T message){
  logger.w(message);
}

ptrace<T>(T message){
  logger.t(message);
}

pdebug<T>(T message){
  logger.d(message);
}