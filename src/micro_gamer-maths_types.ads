
package Micro_Gamer.Maths_Types is

   type Value is delta 0.001 digits 9;

   type Dimensionless is new Value
     with
       Dimension_System =>
         ((Unit_Name => Meter,    Unit_Symbol => 'm',   Dim_Symbol => 'L'),
          (Unit_Name => Kilogram, Unit_Symbol => "kg",  Dim_Symbol => 'M'),
          (Unit_Name => Second,   Unit_Symbol => 's',   Dim_Symbol => 'T'),
          (Unit_Name => Ampere,   Unit_Symbol => 'A',   Dim_Symbol => 'I'),
          (Unit_Name => Kelvin,   Unit_Symbol => 'K',   Dim_Symbol => '@'),
          (Unit_Name => Mole,     Unit_Symbol => "mol", Dim_Symbol => 'N'),
          (Unit_Name => Candela,  Unit_Symbol => "cd",  Dim_Symbol => 'J'));

   subtype Length_Value is Dimensionless
     with
       Dimension => (Symbol => 'm',
                     Meter  => 1,
                     others => 0);

   subtype Mass_Value is  Dimensionless
     with
       Dimension => (Symbol => "kg",
                     Kilogram => 1,
                     others   => 0);

   subtype Time_Value is Dimensionless
     with
       Dimension => (Symbol => 's',
                     Second => 1,
                     others => 0);

   subtype Speed_Value is Dimensionless
     with
       Dimension => (Meter  =>  1,
                     Second => -1,
                     others =>  0);

   subtype Acceleration_Value is Dimensionless
     with
       Dimension => (Meter  =>  1,
                     Second => -2,
                     others =>  0);

   subtype Force_Value is Dimensionless
     with
       Dimension => (Symbol => 'N',
                     Meter    => 1,
                     Kilogram => 1,
                     Second   => -2,
                     others   => 0);

   subtype Angle_Value is Dimensionless
     with
      Dimension => (Symbol => "rad",
                    others => 0);

   pragma Warnings (Off, "*assumed to be*");

   m   : constant Length_Value := 1.0;
   kg  : constant Mass_Value   := 1.0;
   s   : constant Time_Value   := 1.0;
   N   : constant Force_Value  := 1.0;
   rad : constant Angle_Value  := 1.0;
   Pi  : constant Angle_Value  := 3.14;

   pragma Warnings (On, "*assumed to be*");

   type Position_Type is record
      X, Y : Length_Value;
   end record;

   Origin : constant Position_Type := (0.0 * m, 0.0 * m);

   type Rectangle is record
      Org    : Position_Type;
      Width  : Length_Value;
      Height : Length_Value;
   end record;

   type Circle is record
      Org    : Position_Type;
      Radius : Length_Value;
   end record;

   type Force_Vect is record
      X, Y : Force_Value;
   end record;

   No_Force : constant Force_Vect := (0.0 * N, 0.0 * N);

   type Speed_Vect is record
      X, Y : Speed_Value;
   end record;

   No_Speed : constant Speed_Vect := (Speed_Value (0.0), Speed_Value (0.0));

   type Acceleration_Vect is record
      X, Y : Acceleration_Value;
   end record;

   No_Acceleration : constant Acceleration_Vect :=
     (Acceleration_Value (0.0),
      Acceleration_Value (0.0));

end Micro_Gamer.Maths_Types;
