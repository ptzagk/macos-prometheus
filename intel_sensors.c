#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>

#include <IntelPowerGadget/EnergyLib.h>

int main(int argc, char* argv[]) {

  IntelEnergyLibInitialize();
  StartLog("/tmp/PowerGadgetLog.csv"); // causes a sample to be read

  int numMsrs = 0;
  GetNumMsrs(&numMsrs);

  sleep(1);
  ReadSample();

  for (int j = 0; j < numMsrs; j++) {
    int funcID;
    char szName[1024];
    GetMsrFunc(j, &funcID);
    GetMsrName(j, szName);
    for (int i = 0; szName[i]; i++) {
      if (szName[i] == ' ') {
        szName[i] = '_';
      } else {
        szName[i] = tolower(szName[i]);
      }
    }

    int nData;
    double data[3];
    GetPowerData(0, j, data, &nData);

    // Frequency
    if (funcID == MSR_FUNC_FREQ) {
      printf("node_sensors_megahertz{sensor=\"%s\"} %4.0f\n", szName, data[0]);
    }

    // Power
    else if (funcID == MSR_FUNC_POWER) {
      printf("node_sensors_watts{sensor=\"%s\"} %3.2f\n", szName, data[0]);
      printf("node_sensors_joules{sensor=\"%s\"} %3.2f\n", szName, data[1]);
    }

    // Temperature
    else if (funcID == MSR_FUNC_TEMP) {
      printf("node_sensors_celsius{sensor=\"%s\"} %3.0f\n", szName, data[0]);
    }
  }
  printf("\n");

  sleep(1);
  StopLog(); // causes a sample to be read

  return 0;
}
