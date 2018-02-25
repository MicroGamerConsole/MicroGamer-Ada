
with HAL;
with HAL.Bitmap;

package Micro_Gamer is

   Width  : constant := 128;
   Height : constant := 64;

   function Initialized return Boolean;

   procedure Initalize
     with Post => Initialized;

   function Buffer return not null HAL.Bitmap.Any_Bitmap_Buffer
     with Pre => Initialized;

   procedure Update
     with Pre => Initialized;

   type Buttons is (A, B, X, Y, Up, Down, Left, Right);

   function Pressed (Btn : Buttons) return Boolean
     with Pre => Initialized;

   procedure Delay_Ms (Ms : HAL.UInt64);

end Micro_Gamer;
