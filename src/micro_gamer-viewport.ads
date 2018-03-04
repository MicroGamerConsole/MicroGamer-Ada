with Micro_Gamer.Maths_Types;
with HAL.Bitmap;

package Micro_Gamer.Viewport is

   --  The viewport is a rectangle in the virtual world that defines the area
   --  that can be seen on the screen.
   --
   --  When rendering an object from the virtual world to the screen, a
   --  transformation must be used.

   procedure Set (Rect : Maths_Types.Rectangle);
   --  Set the viewport in the virtual world

   function Port return Maths_Types.Rectangle;
   --  Get the viewport in the virtual world

   function Transform (World  :     Maths_Types.Position_Type;
                       Screen : out HAL.Bitmap.Point)
                       return Boolean;
   --  Transform a point from the virtual world to screen coordinates.
   --  Return False when the point is not inside the view port.

   procedure Transform (Screen :     HAL.Bitmap.Point;
                        World  : out Maths_Types.Position_Type);
   --  Transform a point from screen coordinate to the virtual world

   function Transform (World  :     Maths_Types.Rectangle;
                       Screen : out HAL.Bitmap.Rect)
                       return Boolean;
   --  Transform a rectangle from the virtual world to screen coordinates.
   --  Return False when the rectangle is not inside the view port.

   procedure Transform (Screen :     HAL.Bitmap.Rect;
                        World  : out Maths_Types.Rectangle);
   --  Transform a rectangle from screen coordinate to the virtual world

end Micro_Gamer.Viewport;
