import sys
import os

def float_to_q15(value):
    # Ensure the value is within the range [-1, 1)
    if value > 1.0:
        value = 1.0
    elif value < -1.0:
        value = -1.0
    
    # Convert to Q15 format
    q15_value = int(round(value * 32767))
    return q15_value

def convert_txt_to_c_array(input_txt_file):
    float_coefficients = []
    
    # Read floating-point coefficients from the input .txt file
    with open(input_txt_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line:
                # Replace comma with period for decimal conversion
                line = line.replace(',', '.')
                try:
                    float_coefficients.append(float(line))
                except ValueError:
                    print(f"Warning: Skipping line due to invalid format: {line}")
    
    # Convert each coefficient to Q15 format
    q15_coefficients = [float_to_q15(coef) for coef in float_coefficients]

    # Derive output .c file name from input .txt file
    base_name = os.path.splitext(input_txt_file)[0]
    output_c_file = f"{base_name}.c"

    # Write the Q15 coefficients to the output .c file as a C array
    with open(output_c_file, 'w') as f:
        f.write("#include <stdint.h>\n\n")
        f.write(f"#define NUM_COEFFICIENTS {len(q15_coefficients)}\n\n")
        f.write("int16_t filter_coefficients[NUM_COEFFICIENTS] = {\n")
        f.write(",\n".join(f"    {q15_coef}" for q15_coef in q15_coefficients))
        f.write("\n};\n")

    print(f"Conversion complete! Q15 coefficients written to {output_c_file}")

# CLI usage
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python convert_to_q15.py <input_txt_file>")
        sys.exit(1)
    
    input_txt_file = sys.argv[1]
    if not os.path.isfile(input_txt_file):
        print(f"Error: File '{input_txt_file}' not found.")
        sys.exit(1)

    convert_txt_to_c_array(input_txt_file)
