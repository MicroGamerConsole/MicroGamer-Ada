with HAL;                     use HAL;
with HAL.Bitmap;
with Micro_Gamer;             use Micro_Gamer;
with Micro_Gamer.Maths_Types; use Micro_Gamer.Maths_Types;
with Micro_Gamer.Maths;       use Micro_Gamer.Maths;
with Micro_Gamer.Viewport;

with Micro_Gamer.Memory_Card;

with Tiny_Tanks;         use Tiny_Tanks;
with Tiny_Tanks.Terrain;

with Semihosting;

procedure Main is
   T1   : Tank;
   Port : Micro_Gamer.Maths_Types.Rectangle;

   type Test_Save_Data is record
      A, B, C, D : Integer;
   end record;

   package Mem is new Micro_Gamer.Memory_Card (Test_Save_Data);

begin
   --  Micro_Gamer.Sound.Play (Song.The_Melody, True);

   Mem.Load;

   Semihosting.Log_Line ("Loaded data:");
   Semihosting.Log_Line ("A:" & Mem.Data.A'Img);
   Semihosting.Log_Line ("B:" & Mem.Data.B'Img);
   Semihosting.Log_Line ("C:" & Mem.Data.C'Img);
   Semihosting.Log_Line ("D:" & Mem.Data.D'Img);

   if Mem.Data.A /= 42 then
      Mem.Data.A := 42;
      Mem.Data.B := 51;
      Mem.Data.C := -42;
      Mem.Data.D := 127;
      Mem.Save;
   end if;

   Micro_Gamer.Initialize;
   Micro_Gamer.Set_Frame_Rate (25);
   Micro_Gamer.Buffer.Set_Source (0);
   Micro_Gamer.Buffer.Fill;

   Tiny_Tanks.Terrain.Create;

   T1.Spawn (Length_Value (20.0));

   loop
      if Micro_Gamer.Pressed (Micro_Gamer.A) then
         if Micro_Gamer.Pressed (Up) then
            Port := Viewport.Port;
            Port.Org.Y := Port.Org.Y - 1 * m;
            Viewport.Set (Port);
         elsif Micro_Gamer.Pressed (Down) then
            Port := Viewport.Port;
            Port.Org.Y := Port.Org.Y + 1 * m;
            Viewport.Set (Port);
         end if;

         if Micro_Gamer.Pressed (Right) then
            Port := Viewport.Port;
            Port.Org.X := Port.Org.X - 1 * m;
            Viewport.Set (Port);
         elsif Micro_Gamer.Pressed (Left) then
            Port := Viewport.Port;
            Port.Org.X := Port.Org.X + 1 * m;
            Viewport.Set (Port);
         end if;
      elsif Micro_Gamer.Pressed (Micro_Gamer.X) then
         if Micro_Gamer.Pressed (Up) then
            T1.Increase_Angle (To_Rad (5.0));
         elsif Micro_Gamer.Pressed (Down) then
            T1.Decrease_Angle (To_Rad (5.0));
         end if;

         if Micro_Gamer.Pressed (Right) then
            T1.Increase_Power (1.0);
         elsif Micro_Gamer.Pressed (Left) then
            T1.Decrease_Power (1.0);
         end if;

      else
         if Micro_Gamer.Pressed (Right) then
            T1.Move (Length_Value (1.0));
         elsif Micro_Gamer.Pressed (Left) then
            T1.Move (Length_Value (-1.0));
         end if;
      end if;

      if Micro_Gamer.Pressed (Micro_Gamer.Y) then
         T1.Fire;
      end if;

      T1.Step (Time_Value (1.0 / 25.0));
      T1.Draw;
      Terrain.Draw;

      Micro_Gamer.Wait_Until_Next_Frame;
      Micro_Gamer.Show_FPS;
      Micro_Gamer.Update;
      Micro_Gamer.Buffer.Set_Source (0);
      Micro_Gamer.Buffer.Fill;
   end loop;
end Main;
