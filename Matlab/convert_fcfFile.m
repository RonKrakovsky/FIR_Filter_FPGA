clear;


coeff = 16;
flag = 0;
% Open the FCF file
file_id = fopen('coeff.fcf', 'r');

% Read the file line by line
line_number = coeff; 
H = zeros(1,coeff);

while ~feof(file_id)
    line = fgetl(file_id);
    
    if flag == 1
        if line_number == 0 
            H(1,coeff+1) = str2double(line);
            break;
        else
            H(1,coeff-line_number+1) = str2double(line);
            line_number = line_number - 1;
        end
    end

    % Check if the line contains "Numerator:"
    if contains(line, 'Numerator:')
        numerator_line = line;
        flag = 1;
    end

    
end

fix_point_decimal = zeros(1,coeff);
s = coeff;
for c = 1:s
   fix_point_decimal(1,c) = Convert_FixPoint(H(1,c));
end

% Close the file
fclose(file_id);

function fix_point = Convert_FixPoint(a)

    % Define the fixed-point data type
    %word_length = 16;
    fraction_length = 14;
    
    % Convert the double number to fixed point
    number_word_length = round(round(a) * 2^fraction_length);
    number_fraction_length = round((a - round(a))*2^fraction_length);
    
    fix_point = number_word_length + number_fraction_length;
end




