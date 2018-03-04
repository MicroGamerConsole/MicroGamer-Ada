with HAL;                     use HAL;
with Micro_Gamer.Math_Tables; use Micro_Gamer.Math_Tables;

package body Micro_Gamer.Maths is

   ---------
   -- Sin --
   ---------

   function Sin
     (A : Angle_Value)
      return Dimensionless
   is
   begin
      return Sine_Table (UInt32 (A * Sine_Alpha) and (Sine_Table_Size - 1));
   end Sin;

   ---------
   -- Cos --
   ---------

   function Cos
     (A : Angle_Value)
      return Dimensionless
   is
   begin
      return Cos_Table (UInt32 (A * Cos_Alpha) and (Cos_Table_Size - 1));
   end Cos;

   ----------------
   -- To_Degrees --
   ----------------

   function To_Degrees (A : Angle_Value) return Dimensionless
   is (A * 360.0 / (Pi * 2.0));

   ---------
   -- To_ --
   ---------

   function To_Rad (A : Dimensionless) return Angle_Value
   is (Angle_Value (Angle_Value (A) * Angle_Value (Pi * 2.0)) / Angle_Value (360.0));


end Micro_Gamer.Maths;
