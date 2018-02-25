with HAL.Bitmap;
with Micro_Gamer; use Micro_Gamer;

procedure Main is
   X, Y : Natural := 50;
begin

   Micro_Gamer.Initalize;
   Micro_Gamer.Buffer.Set_Source (0);
   Micro_Gamer.Buffer.Fill;

   loop
      if Micro_Gamer.Pressed (Up) and then Y < Micro_Gamer.Height - 1 then
         Y := Y - 1;
      elsif Micro_Gamer.Pressed (Down) and then Y > 0 then
         Y := Y + 1;
      end if;

      if Micro_Gamer.Pressed (Right) and then X < Micro_Gamer.Width - 1 then
         X := X + 1;
      elsif Micro_Gamer.Pressed (Left) and then X > 0 then
         X := X - 1;
      end if;

      if Micro_Gamer.Pressed (Micro_Gamer.X) then
         Micro_Gamer.Buffer.Set_Source (0);
         Micro_Gamer.Buffer.Fill;
      end if;

      Micro_Gamer.Buffer.Set_Source (1);
      Micro_Gamer.Buffer.Set_Pixel ((X, Y));
      Micro_Gamer.Update;

   end loop;
end Main;
