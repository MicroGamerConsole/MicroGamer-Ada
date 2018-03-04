with Micro_Gamer.Maths_Types; use Micro_Gamer.Maths_Types;

package body Micro_Gamer.Viewport is

   The_Port : Maths_Types.Rectangle := ((0.0 * m, 0.0 * m),
                                        Length_Value (Width),
                                        Length_Value (Height));

   ---------
   -- Set --
   ---------

   procedure Set (Rect : Maths_Types.Rectangle) is
   begin
      The_Port := Rect;
   end Set;

   ----------
   -- Port --
   ----------

   function Port return Maths_Types.Rectangle
   is (The_Port);

   ---------------
   -- Transform --
   ---------------

   function Transform
     (World  :     Maths_Types.Position_Type;
      Screen : out HAL.Bitmap.Point)
      return Boolean
   is
      X, Y : Integer;
   begin
      X := Integer (World.X + The_Port.Org.X);
      Y := Integer (World.Y + The_Port.Org.Y);

      if X in 0 .. Width - 1 and then Y in 0 .. Height - 1 then
         Screen := (X, Y);
         return True;
      else
         return False;
      end if;
   end Transform;

   ---------------
   -- Transform --
   ---------------

   procedure Transform
     (Screen :     HAL.Bitmap.Point;
      World  : out Maths_Types.Position_Type)
   is
   begin
      World := (Length_Value (Screen.X), Length_Value (Screen.Y));
   end Transform;

   ---------------
   -- Transform --
   ---------------

   function Transform
     (World  :     Maths_Types.Rectangle;
      Screen : out HAL.Bitmap.Rect)
      return Boolean
   is
      X1, X2, Y1, Y2 : Integer;
   begin
      X1 := Integer (World.Org.X + The_Port.Org.X);
      Y1 := Integer (World.Org.Y + The_Port.Org.Y);

      X2 := Integer (World.Org.X + World.Width + The_Port.Org.X);
      Y2 := Integer (World.Org.Y + World.Height + The_Port.Org.Y);

      if X1 in 0 .. Width - 1 and then Y1 in 0 .. Height - 1
        and then
         X2 in 0 .. Width - 1 and then Y2 in 0 .. Height - 1
      then
         Screen := ((X1, Y1), (X2 - X1), (Y2 - Y1));
         return True;
      else
         return False;
      end if;
   end Transform;

   ---------------
   -- Transform --
   ---------------

   procedure Transform
     (Screen :     HAL.Bitmap.Rect;
      World  : out Maths_Types.Rectangle)
   is
   begin
      World := ((Length_Value (Screen.Position.X),
                 Length_Value (Screen.Position.Y)),
                Length_Value (Screen.Width),
                Length_Value (Screen.Height));
   end Transform;

end Micro_Gamer.Viewport;
