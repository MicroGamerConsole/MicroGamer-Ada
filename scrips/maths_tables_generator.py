import math

SAMPLES = 256

sine_str =  "   Sine_Table_Size : constant := %d;\n" % SAMPLES
sine_str += "   Sine_Alpha      : constant := Dimensionless (Sine_Table_Size) / (2 * 3.14159);\n"
sine_str += "   pragma Style_Checks (Off);\n"
sine_str += "   Sine_Table : constant array (UInt32 range 0 .. Sine_Table_Size - 1) of Dimensionless :=\n"
sine_str += "    ("

cnt = 0
for sample in range(SAMPLES):
    angle = (sample * 2 * 3.14159) / SAMPLES
    sine = math.sin(angle)

    sine_str += "%6.3f%s" % (sine, "," if sample != SAMPLES - 1 else "")
    if cnt == 5:
        cnt = 0
        sine_str += "\n" + " " * 5
    else:
        cnt = cnt + 1

sine_str += ");\n"
sine_str += "   pragma Style_Checks (On);\n"

cos_str =  "   Cos_Table_Size : constant := %d;\n" % SAMPLES
cos_str += "   Cos_Alpha      : constant := Dimensionless (Cos_Table_Size) / (2 * 3.14159);\n"
cos_str += "   pragma Style_Checks (Off);\n"
cos_str += "   Cos_Table : constant array (UInt32 range 0 .. Cos_Table_Size - 1) of Dimensionless :=\n"
cos_str += "    ("

cnt = 0
for sample in range(SAMPLES):
    angle = (sample * 2 * 3.14159) / SAMPLES
    cos = math.cos(angle)

    cos_str += "%6.3f%s" % (cos, "," if sample != SAMPLES - 1 else "")
    if cnt == 5:
        cnt = 0
        cos_str += "\n" + " " * 5
    else:
        cnt = cnt + 1

cos_str += ");\n"
cos_str += "   pragma Style_Checks (On);\n"


print "with HAL;                     use HAL;"
print "with Micro_Gamer.Maths_Types; use Micro_Gamer.Maths_Types;"
print
print "package Micro_Gamer.Math_Tables is"
print

print sine_str
print
print cos_str

print "end Micro_Gamer.Math_Tables;"

