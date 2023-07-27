clear;

% Define the input double number
input_double = -0.005048452036381452685820381276471380261;

% Define the fixed-point data type
word_length = 16;
fraction_length = 14;

% Convert the double number to fixed point
number_word_length = round(round(input_double) * 2^fraction_length);
number_fraction_length = round((input_double - round(input_double))*2^fraction_length);

fix_point = number_word_length + number_fraction_length;