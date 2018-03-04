with HAL;                     use HAL;
with Micro_Gamer.Maths_Types; use Micro_Gamer.Maths_Types;
with Micro_Gamer.Physics;     use Micro_Gamer.Physics;

package Tiny_Tanks is

   type Tank is new Micro_Gamer.Physics.Object with private;

   procedure Fire (This : in out Tank);
   --  Fire!!!

   procedure Increase_Power (This   : in out Tank;
                             Amount : Dimensionless);

   procedure Decrease_Power (This   : in out Tank;
                             Amount : Dimensionless);

   procedure Increase_Angle (This   : in out Tank;
                             Amount : Angle_Value);

   procedure Decrease_Angle (This   : in out Tank;
                             Amount : Angle_Value);

   procedure Spawn (This : in out Tank; X : Length_Value);

   procedure Move (This : in out Tank; Amount : Length_Value);

   overriding
   procedure Step (This : in out Tank; Elapsed : Time_Value);

   procedure Draw (This : Tank);

private

   type Bomb is new Micro_Gamer.Physics.Object with record
      Alive : Boolean := False;
   end record;

   type Bomb_Index is range 1 .. 25;

   type Bomb_array is array (Bomb_Index) of Bomb;

   subtype Fire_Power is Dimensionless range 1.0 .. 100.0;

   subtype Fire_Angle is Angle_Value range 0.0 .. Pi;

   type Tank is new Micro_Gamer.Physics.Object with record
      Bombs     : Bomb_array;
      Power     : Fire_Power := 25.0;
      Angle     : Fire_Angle := Pi / 4.0;
      Last_Fire : HAL.UInt64 := 0;

      X1, X2 : Length_Value := Length_Value (0.0); -- X coord of the front and back of the tank
      E1, E2 : Length_Value := Length_Value (0.0); -- Elevation of the front and back of the tank
   end record;

   Min_Fire_Interval_Ms : constant := 100;
end Tiny_Tanks;
