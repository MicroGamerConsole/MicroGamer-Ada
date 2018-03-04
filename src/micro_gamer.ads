
with HAL;
with HAL.Bitmap;

package Micro_Gamer is

   Width  : constant := 128;
   Height : constant := 64;

   --------------------
   -- Initialization --
   --------------------

   function Initialized return Boolean;

   procedure Initialize
     with Post => Initialized;

   ------------
   -- Screen --
   ------------

   function Buffer return not null HAL.Bitmap.Any_Bitmap_Buffer
     with Pre => Initialized;
   --  Return a not null access to the frame buffer

   procedure Update
     with Pre => Initialized;
   --  Update the screen with the current content of the frame buffer

   ------------------------
   -- Frame rate control --
   ------------------------

   procedure Set_Frame_Rate (Rate : Positive);
   --  Set the desired frame rate. See Wait_Until_Next_Frame for an example of
   --  render loop.

   procedure Wait_Until_Next_Frame
     with Pre => Initialized;
   --  Wait until it is time to display the next frame.
   --
   --  Example:
   --     Set_Frame_Rate (25);
   --     loop
   --        Render_Frame;
   --        Wait_Until_Next_Frame;
   --        Update;
   --     end loop;

   procedure Show_FPS
     with Pre => Initialized;
   --  Display the Frame Per Second counter on the upper-left corner of the
   --  screen. This procedure should be called before each screen update.
   --  (For use during developement)

   ----------
   -- Text --
   ----------

   type Fonts is (Font8x8, Font12x12, Font16x24);

   procedure Select_Font (Font : Fonts);
   --  Select the font to be used in future calls to Print

   procedure Set_Cursor (Pt : HAL.Bitmap.Point);
   --  Set the posistion of the text cursor

   procedure Set_Text_Color (C : HAL.Bitmap.Bitmap_Color);
   --  Set the text color to be used in in future calls to Print

   procedure Set_Text_Background (C : HAL.Bitmap.Bitmap_Color);
   --  Set the text background color to be used in in future calls to Print

   procedure Print (Str : String)
     with Pre => Initialized;
   --  Print a string at the current cursor posistion using the selected font

   -------------
   -- Buttons --
   -------------

   type Buttons is (A, B, X, Y, Up, Down, Left, Right);

   function Pressed (Btn : Buttons) return Boolean
     with Pre => Initialized;
   --  Return True if a button is pressed

   ----------
   -- Time --
   ----------

   function Clock_Ms return HAL.UInt64;
   --  Return the number of milliseconds elapsed since the start of the system

   procedure Delay_Ms (Ms : HAL.UInt64);
   --  Put the system in sleep mode during Ms milliseconds

   ------------
   -- Random --
   ------------

   function Random return HAL.UInt8
     with Pre => Initialized;

end Micro_Gamer;
