package Tiny_Tanks.Terrain is

   procedure Create;

   function Test_Bomb_Hit (P : Position_Type) return Boolean;

   function Elevation (X : Length_Value) return Length_Value;

   procedure Draw;

private

   procedure Bomb_Hit (P : Position_Type);

end Tiny_Tanks.Terrain;
