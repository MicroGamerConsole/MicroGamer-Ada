with Micro_Gamer.Maths_Types; use Micro_Gamer.Maths_Types;

package Micro_Gamer.Maths is

   function Sin (A : Angle_Value) return Dimensionless
     with Post => Sin'Result in -1.0 .. 1.0;

   function Cos (A : Angle_Value) return Dimensionless
     with Post => Cos'Result in -1.0 .. 1.0;

   function To_Degrees (A : Angle_Value) return Dimensionless;

   function To_Rad (A : Dimensionless) return Angle_Value;

end Micro_Gamer.Maths;
