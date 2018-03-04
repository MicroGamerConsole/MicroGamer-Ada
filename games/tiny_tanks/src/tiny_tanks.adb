with Micro_Gamer;          use Micro_Gamer;
with Micro_Gamer.Viewport;
with Micro_Gamer.Sound;
with Tiny_Tanks.Sounds;
with Tiny_Tanks.Terrain;

with HAL.Bitmap;

with Micro_Gamer.Maths; use Micro_Gamer.Maths;

package body Tiny_Tanks is

   ----------
   -- Fire --
   ----------

   procedure Fire (This : in out Tank) is
      Now : constant UInt64 := Micro_Gamer.Clock_Ms;
   begin

      if This.Last_Fire + Min_Fire_Interval_Ms > Now then
         --  Can't fire now
         return;
      end if;

      for B of This.Bombs loop
         if not B.Alive then
            B.Set_Mass (Mass_Value (1.0));
            B.Set_Position ((This.Position.X, This.Position.Y + Length_Value (2.0)));
            B.Set_Speed ((Speed_Value (Cos (This.Angle) * This.Power),
                          Speed_Value (Sin (This.Angle) * This.Power)));
            B.Alive := True;
            This.Last_Fire := Now;
            Micro_Gamer.Sound.Play (Tiny_Tanks.Sounds.Fire, False);
            return;
         end if;
      end loop;
   end Fire;

   --------------------
   -- Increase_Power --
   --------------------

   procedure Increase_Power
     (This   : in out Tank;
      Amount : Dimensionless)
   is
   begin
      if This.Power + Amount in Fire_Power'Range then
         This.Power := This.Power + Amount;
      end if;
   end Increase_Power;

   --------------------
   -- Decrease_Power --
   --------------------

   procedure Decrease_Power
     (This   : in out Tank;
      Amount : Dimensionless)
   is
   begin
      if This.Power - Amount in Fire_Power'Range then
         This.Power := This.Power - Amount;
      end if;
   end Decrease_Power;

   --------------------
   -- Increase_Angle --
   --------------------

   procedure Increase_Angle
     (This   : in out Tank;
      Amount : Angle_Value)
   is
   begin
      if This.Angle + Amount in Fire_Angle'Range then
         This.Angle := This.Angle + Amount;
      end if;
   end Increase_Angle;

   --------------------
   -- Decrease_Angle --
   --------------------

   procedure Decrease_Angle
     (This   : in out Tank;
      Amount : Angle_Value)
   is
   begin
      if This.Angle - Amount in Fire_Angle'Range then
         This.Angle := This.Angle - Amount;
      end if;
   end Decrease_Angle;

   -----------
   -- Spawn --
   -----------

   procedure Spawn (This : in out Tank; X : Length_Value)
   is
   begin
      This.Set_Position ((X, Length_Value (0.0)));
      This.Move (Length_Value (0.0));
   end Spawn;

   ----------
   -- Move --
   ----------

   procedure Move (This : in out Tank; Amount : Length_Value)
   is
      Next_X : constant Length_Value := This.Position.X + Amount;
      Next_X1, Next_X2, Next_E1, Next_E2 : Length_Value;
   begin

      Next_X1 := Next_X - Length_Value (3.0);
      Next_X2 := Next_X + Length_Value (3.0);

      Next_E1 := Terrain.Elevation (Next_X1);
      Next_E2 := Terrain.Elevation (Next_X2);

      if abs (Next_E1 - Next_E2) < Length_Value (5.0) then
         This.Set_Position ((Next_X, (Next_E1 + Next_E2) / 2.0));
         This.X1 := Next_X1;
         This.X2 := Next_X2;
         This.E1 := Next_E1;
         This.E2 := Next_E2;
      end if;
   end Move;

   ----------
   -- Step --
   ----------

   overriding
   procedure Step (This : in out Tank; Elapsed : Time_Value)
   is
   begin
      for B of This.Bombs loop
         if B.Alive then
            --  Gravity
            B.Apply_Force ((Force_Value (0.0), -Force_Value (9.51)));
            B.Step (Elapsed);

            if Tiny_Tanks.Terrain.Test_Bomb_Hit (B.Position) then
               Micro_Gamer.Sound.Play (Tiny_Tanks.Sounds.Explosion, False);
               B.Alive := False;
            end if;
         end if;
      end loop;

      Micro_Gamer.Physics.Object (This).Step (Elapsed);
   end Step;

   ----------
   -- Draw --
   ----------

   procedure Draw (This : Tank) is
      Pt1 : HAL.Bitmap.Point;
      Pt2 : HAL.Bitmap.Point;
   begin
      Micro_Gamer.Buffer.Set_Source (1);

      for B of This.Bombs loop
         if B.Alive and then Viewport.Transform (B.Position, Pt1) then
            Micro_Gamer.Buffer.Set_Pixel ((Pt1.X,
                                          Height - 1 - Pt1.Y));
         end if;
      end loop;

      if Viewport.Transform ((This.X1, This.E1), Pt1)
        and then
         Viewport.Transform ((This.X2, This.E2), Pt2)
      then
         Micro_Gamer.Buffer.Draw_Line
           (Start     => (Pt1.X, Height - 1 - Pt1.Y),
            Stop      => (Pt2.X, Height - 1 - Pt2.Y),
            Thickness => 2,
            Fast      => True);
      end if;

      Micro_Gamer.Set_Cursor ((0, 9));
      Micro_Gamer.Print ("Angle:" & Integer'Image (Integer (To_Degrees (This.Angle))));
      Micro_Gamer.Set_Cursor ((0, 18));
      Micro_Gamer.Print ("Power:" & Integer'Image (Integer (This.Power)));
   end Draw;

end Tiny_Tanks;
