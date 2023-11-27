#include <Arduino.h>
#include <SerialCom.h>
#include <EasIno.h>

EasIno* easino;
DataCom data;

#ifndef COMTYPE
#define COMTYPE "SERIAL"
#define BAUD 115200
#endif

void setup() {
  easino = new SerialCom(BAUD);
  easino->start();
}

void loop() {
  data = easino->receive();

  DataCom data_out = DataCom();
  if (strcmp(data.operation, "COMTYPE") == 0) {
    data_out.setOperation("COMTYPE");
    data_out.setArgument(0, COMTYPE);
    data_out.setArgument(1, BAUD);
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST001") == 0) {
    data_out.builder("TEST001;T001_0ARG;T001_1ARG;T001_2ARG;", ';');
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST002") == 0) {
    data_out.builder("TEST002_VERYLONGARGUMENT;T002_0VERYLONGARGUMENT;T002_1VERYLONGARGUMENT;T002_2VERYLONGARGUMENT;", ';');
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST003") == 0) {
    data_out.builder("TEST003$T003_0ARG$T003_1ARG$T003_2ARG$", '$');
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST004") == 0) {
    data_out.builder("TEST004;T004_0ARG;T004_1ARG;T004_2ARG;T004_3ARG;T004_4ARG;T004_5ARG;", ';');
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST005") == 0) {
    data_out.builder("TEST005;T005_0ARG;;T005_2ARG;", ';');
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST006123456789123") == 0) {
    data_out.builder("TEST006;T006_0ARG;T006_1ARG;T006_2ARG;", ';');
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST025") == 0) {
    data_out.setOperation("TEST025");
    data_out.setArgument(0, 10);
    data_out.setArgument(1, 0);
    data_out.setArgument(2, -10);
    data_out.setArgument(3, (int)0.3);
    data_out.setArgument(4, false);
    data_out.setArgument(5, true);
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST026") == 0) {
    data_out.setOperation(26);
    data_out.setArgument(0, true);
    data_out.setArgument(1, "T026_1VERYLONGARGUMENT");
    data_out.setArgument(2, '(');
    data_out.setArgument(3, (char)0);
    data_out.setArgument(4, (char)1);
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST027") == 0) {
    data_out.setOperation((double)27, 2);
    data_out.setArgument(0, 1.0, 3);
    data_out.setArgument(1, -1.12, 0);
    data_out.setArgument(2, -575.123, 2);
    data_out.setArgument(3, 99.0, 999);
    data_out.setArgument(4, 0.3, 2);
    easino->send(data_out);
  } else if (strcmp(data.operation, "TEST028") == 0) {
    data_out.setOperation(2.8, 1);
    data_out.setArgument(1, 99.125, -1);
    easino->send(data_out);
  }
}
