#!/usr/bin/env python3
'''VHDLSinGenerator.py - Pedro José Pereira Vieito © 2016
  Generate sine waves for a VHDL test bench.
Usage:
  VHDLSinGenerator.py <sample_bits> <wave_bits>
Options:
  -h, --help  show this help
'''

import math
from docopt import docopt

args = docopt(__doc__)

sample_bits = int(args['<sample_bits>'])
wave_bits = int(args['<wave_bits>'])

samples = 2 ** sample_bits
wave_amp = 2 ** (wave_bits - 1)

print('-- Auxiliary signals')
print('signal table_counter : std_logic_vector(' + str(sample_bits - 1) +
      ' downto 0) := "' + '0' * sample_bits + '";')
print('signal table_value : std_logic_vector(' + str(wave_bits - 1) +
      ' downto 0) := "' + '0' * wave_bits + '";\n')

print('-- Sine wave table')
print('table_value <=  ', end='')
for i in range(samples):
    new_sample = int(wave_amp + (wave_amp - 1) *
                     math.sin(2 * math.pi * i / samples))
    print('"' + bin(new_sample)[2:].zfill(wave_bits) +
          '" when table_counter =', i, end='')
    if i == samples - 1:
        print(";")
    else:
        print(" else")