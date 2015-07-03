#!/usr/bin/env python


#  < Ensamblador para la tarea 4 y5. IE0521: Estructura de computadores Digitales II. Universidad de Costa Rica >
#    Copyright (C) 2015  Guillermo Cornejo Suarez luis.cornejo@ucr.ac.cr
#                        Marco Torrres Umana      marco.torres.810@gmail.com
#                        Erick Eduarte Rojas      erickedur@gmail.com 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys

def main(argv):
    if not len(argv) == 3:
        print 'No input or output file name given'
        print 'Usage: assambler.py input_file output_file'
        sys.exit(1)
#    print 'reading text'
    
    in_file  = open(argv[1])
    out_file = open(argv[2], 'w')
    tag_dic = {}
    
    # loop para resolver todos los tags
    eof = False
    instruction_number = 0
       
    while not eof:
        line = in_file.readline().split(' ')
        if(line[0] == ''):
            eof = True
        elif(line[0] == '#'):
            instruction_number = instruction_number -1            
        elif(line[0] == ':'):
            instruction_number = instruction_number - 1
            tag_dic.update({line[1]:(instruction_number + 1)})            
    
        instruction_number = instruction_number + 1
    
    print tag_dic
    in_file.seek(0) # De vuelta al bit 0 del archivo

    # Loop para escribir todas las instrucciones
    eof = False
    instruction_number = 0
    
    while not eof:
        instruction = ''
        line = in_file.readline().split(' ')
#        print line  Imprimir para debugging

        if(line[0] == ''):
            eof = True
        elif(line[0] == '#'):
            instruction_number = instruction_number -1    
        elif(line[0] == ':'):
            instruction_number = instruction_number -1
        elif(line[0] == 'LDA'):
            instruction = instruction + '000000'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'LDB'):
            instruction = instruction + '000001'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'LDCA'):
            instruction = instruction + '000010'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'LDCB'):
            instruction = instruction + '000011'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'STA'):
            instruction = instruction + '000100'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'STB'):
            instruction = instruction + '000101'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ADDA\n'):
            instruction = instruction + '000110'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ADDB\n'):
            instruction = instruction + '000111'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ADDCA'):
            instruction = instruction + '001000'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ADDCB'):
            instruction = instruction + '001001'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'SUBA\n'):
            instruction = instruction + '001010'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'SUBB\n'):
            instruction = instruction + '001011'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'SUBCA'):
            instruction = instruction + '001100'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'SUBCB'):
            instruction = instruction + '001101'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ANDA\n'):
            instruction = instruction + '001110'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ANDB\n'):
            instruction = instruction + '001111'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ANDCA'):
            instruction = instruction + '010000'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ANDCB'):
            instruction = instruction + '010001'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ORA\n'):
            instruction = instruction + '010010'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ORB\n'):
            instruction = instruction + '010011'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ORCA'):
            instruction = instruction + '010100'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ORCB'):
            instruction = instruction + '010101'
            instruction = instruction + bin(int(line[1][:3], 16))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ASLA\n'):
            instruction = instruction + '010110'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'ASRA\n'):
            instruction = instruction + '010111'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'JMP'):
            instruction = instruction + '011000'
            instruction = instruction + bin(int(tag_dic[line[1][:2]]))[2:].zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
        elif(line[0] == 'BAEQ'):
            instruction = instruction + '011001'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BANE'):
            instruction = instruction + '011010'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BACS'):
            instruction = instruction + '011011'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BACC'):
            instruction = instruction + '011100'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BAMI'):
            instruction = instruction + '011101'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BAPL'):
            instruction = instruction + '011110'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BBEQ'):
            instruction = instruction + '011111'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BBNE'):
            instruction = instruction + '100000'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BBCS'):
            instruction = instruction + '100001'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BBCC'):
            instruction = instruction + '100010'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BBMI'):
            instruction = instruction + '100011'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'BBPL'):
            instruction = instruction + '100100'
            jump_address = bin(int(tag_dic[line[1]]) - instruction_number)
            if jump_address[0] == '-':
                jump_address = '1' + jump_address[3:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            else:
                jump_address = '0' + jump_address[2:].zfill(6)
                instruction = instruction + jump_address.zfill(10) + '\n'
            out_file.write(instruction)            
        elif(line[0] == 'NOP\n'):
            instruction = instruction + '100101'
            instruction = instruction + ''.zfill(10)
            instruction = instruction + '\n'
            out_file.write(instruction)
          
        instruction_number = instruction_number + 1
	    
    in_file.close()
    out_file.close()

	
if __name__ == "__main__":
   main(sys.argv)
   
   
   
   
   
   
   
   
   
   
   
   
   
   
