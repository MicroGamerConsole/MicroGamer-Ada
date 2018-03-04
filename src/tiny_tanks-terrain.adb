with HAL.Bitmap;

with Micro_Gamer;          use Micro_Gamer;
with Micro_Gamer.Viewport;
package body Tiny_Tanks.Terrain is

   Max_Height : constant := 80;

   subtype Terrain_Range is Integer range 0 .. Micro_Gamer.Width;

   Data : array (Terrain_Range) of UInt8 := (others => 0);

   ------------
   -- Create --
   ------------

   procedure Create is
      Last : UInt8 := 10;
   begin
      for H of Data loop
         case Micro_Gamer.Random mod 3 is
            when      0 =>
               if Last < Max_Height then
                  H := Last + 1;
               else
                  H := Last;
               end if;
            when      1 =>
               if Last > 0 then
                  H := Last - 1;
               else
                  H := Last;
               end if;
            when others =>
               H := Last;
         end case;
         Last := H;
      end loop;
   end Create;

   -------------------
   -- Test_Bomb_Hit --
   -------------------

   function Test_Bomb_Hit (P : Position_Type) return Boolean is
   begin
      if Integer (P.X) in Terrain_Range
        and then
          P.Y < Length_Value (Data (Integer (P.X)))
      then
         --  Hit;
         Bomb_Hit (P);
         return True;
      else
         return P.Y < 0.0 * m;
      end if;
   end Test_Bomb_Hit;

   ----------
   -- Draw --
   ----------

   procedure Draw is
      Pt : HAL.Bitmap.Point;
   begin
      Micro_Gamer.Buffer.Set_Source (1);
      for X in Terrain_Range'First .. Terrain_Range'Last - 1  loop

         if Viewport.Transform ((Length_Value (X), Length_Value (Data (X))), Pt) then
            Micro_Gamer.Buffer.Draw_Line (Start     => (Pt.X, Height - 1 - Pt.Y),
                                          Stop      => (Pt.X, Height - 1),
                                          Thickness => 1,
                                          Fast      => True);
         end if;
      end loop;
   end Draw;

   ---------------
   -- Elevation --
   ---------------

   function Elevation (X : Length_Value) return Length_Value
   is
   begin
      if Integer (X) in Terrain_Range then
         return Length_Value (Data (Integer (X)));
      else
         return Length_Value (0.0);
      end if;
   end Elevation;

   --------------
   -- Bomb_Hit --
   --------------

   procedure Bomb_Hit (P : Position_Type) is
      Hit_X : constant Integer := Integer (P.X);
   begin
      for X in Integer'Max (Hit_X - 5, Terrain_Range'First) .. Integer'Min (Hit_X + 5, Terrain_Range'Last) loop
         Data (X) := UInt8 (Integer'Max (Integer (Data (X)) - 3, 0));
      end loop;
   end Bomb_Hit;

end Tiny_Tanks.Terrain;
