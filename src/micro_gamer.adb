with HAL;           use HAL;
with MicroBit;      use MicroBit;
with MicroBit.Time;
with nRF51.Device;
with nRF51.GPIO;
with nRF51.TWI;
with nRF51.RNG;
with Bitmapped_Drawing;
with BMP_Fonts;
with HAL.GPIO;

with SSD1306.Standard_Resolutions; use SSD1306.Standard_Resolutions;

package body Micro_Gamer is

   use type HAL.Bitmap.Point;
   use type HAL.GPIO.Any_GPIO_Point;

   Screen_Reset_Pin : nRF51.GPIO.GPIO_Point renames MB_P8;
   Screen_SDA_Pin : nRF51.GPIO.GPIO_Point renames MB_P20;
   Screen_SCL_Pin : nRF51.GPIO.GPIO_Point renames MB_P19;

   Screen_I2C : nRF51.TWI.TWI_Master renames nRF51.Device.TWI_0;

   Screen : SSD1306_128x64_Screen (Screen_I2C'Access,
                                   Screen_Reset_Pin'Access,
                                   MicroBit.Time.HAL_Delay);

   Button_Pins : constant array (Buttons) of not null HAL.GPIO.Any_GPIO_Point :=
     (A     => MB_P5'Access,
      B     => MB_P11'Access,
      X     => MB_P1'Access,
      Y     => MB_P2'Access,
      Up    => MB_P15'Access,
      Down  => MB_P14'Access,
      Left  => MB_P16'Access,
      Right => MB_P13'Access);

   Frame_Duration_Ms : UInt64 := 1000 / 20;
   Next_Frame_Start  : UInt64 := 0;

   FPS_Last_Time : UInt64 := 0;
   FPS_Count : Natural := 0;

   Current_Font : BMP_Fonts.BMP_Font := BMP_Fonts.Font8x8;
   Cursor_Position : HAL.Bitmap.Point;
   Text_FG : HAL.Bitmap.Bitmap_Color := HAL.Bitmap.White;
   Text_BG : HAL.Bitmap.Bitmap_Color := HAL.Bitmap.Black;

   Init_Done : Boolean := False;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean
   is (Init_Done);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      Unref : Boolean with Unreferenced;
   begin

      -- Buttons --

      for Btn of Button_Pins loop
         Unref := Btn.Set_Mode (HAL.GPIO.Input);
         if Btn /= Button_Pins (A) and then Btn /= Button_Pins (B) then
            Unref := Btn.Set_Pull_Resistor (HAL.GPIO.Pull_Up);
         end if;
      end loop;

      -- Screen --
      Unref := Screen_Reset_Pin.Set_Mode (HAL.GPIO.Output);

      Screen_I2C.Configure (SCL   => Screen_SCL_Pin.Pin,
                            SDA   => Screen_SDA_Pin.Pin,
                            Speed => nRF51.TWI.TWI_400kbps);
      Screen_I2C.Enable;
      Screen.Initialize (External_VCC => False);
      Screen.Initialize_Layer (Layer  => 1,
                               Mode   => HAL.Bitmap.M_1);
      Screen.Turn_On;

      Init_Done := True;
   end Initialize;

   ------------
   -- Buffer --
   ------------

   function Buffer
      return not null HAL.Bitmap.Any_Bitmap_Buffer
   is
   begin
      return Screen.Hidden_Buffer (1);
   end Buffer;

   ------------
   -- Update --
   ------------

   procedure Update
   is
   begin

      Next_Frame_Start := MicroBit.Time.Clock + Frame_Duration_Ms;

      Screen.Update_Layers;

   end Update;

   -----------------
   -- Select_Font --
   -----------------

   procedure Select_Font (Font : Fonts) is
   begin
      Current_Font := (case Font is
                          when Font8x8 => BMP_Fonts.Font8x8,
                          when Font12x12 => BMP_Fonts.Font12x12,
                          when Font16x24 => BMP_Fonts.Font16x24);
   end Select_Font;

   ----------------
   -- Set_Cursor --
   ----------------

   procedure Set_Cursor (Pt : HAL.Bitmap.Point)
   is
   begin
      Cursor_Position := Pt;
   end Set_Cursor;

   --------------------
   -- Set_Text_Color --
   --------------------

   procedure Set_Text_Color (C : HAL.Bitmap.Bitmap_Color)
   is
   begin
      Text_FG := C;
   end Set_Text_Color;

   -------------------------
   -- Set_Text_Background --
   -------------------------

   procedure Set_Text_Background (C : HAL.Bitmap.Bitmap_Color)
   is
   begin
      Text_BG := C;
   end Set_Text_Background;

   -----------
   -- Print --
   -----------

   procedure Print (Str : String) is
   begin
      Bitmapped_Drawing.Draw_String (Buffer     => Buffer.all,
                                     Start      => Cursor_Position,
                                     Msg        => Str,
                                     Font       => Current_Font,
                                     Foreground => Text_FG,
                                     Background => Text_BG);
   end Print;

   -------------
   -- Pressed --
   -------------

   function Pressed
     (Btn : Buttons)
      return Boolean
   is
   begin
      return not Button_Pins (Btn).Set;
   end Pressed;

   function Clock_Ms return HAL.UInt64 renames MicroBit.Time.Clock;

   --------------
   -- Delay_Ms --
   --------------

   procedure Delay_Ms (Ms : HAL.UInt64) renames MicroBit.Time.Delay_Ms;

   --------------------
   -- Set_Frame_Rate --
   --------------------

   procedure Set_Frame_Rate (Rate : Positive) is
   begin
      Frame_Duration_Ms := 1000 / UInt64 (Rate);
   end Set_Frame_Rate;

   ---------------------------
   -- Wait_Until_Next_Frame --
   ---------------------------

   procedure Wait_Until_Next_Frame is
      Now : constant UInt64 := Clock_Ms;
   begin
      if Now < Next_Frame_Start then
         Delay_Ms (Next_Frame_Start - Now);
      end if;
   end Wait_Until_Next_Frame;

   --------------
   -- Show_FPS --
   --------------

   procedure Show_FPS is
      Cursor_Backup : constant HAL.Bitmap.Point := Cursor_Position;
      Font_Backup : constant BMP_Fonts.BMP_Font := Current_Font;
   begin
      if FPS_Last_Time + 1000 <= Clock_Ms then

         Buffer.Set_Source (1);

         --  Print the FPS in the upper-left corner
         Current_Font := BMP_Fonts.Font8x8;
         Set_Cursor ((0, 0));
         Print ("FPS:" & FPS_Count'Img);

         --  Restore the font and cursor position
         Set_Cursor (Cursor_Backup);
         Current_Font := Font_Backup;

         FPS_Last_Time := Clock_Ms;
         FPS_Count := 0;
      else
         FPS_Count := FPS_Count + 1;
      end if;
   end Show_FPS;

   ------------
   -- Random --
   ------------

   function Random return HAL.UInt8
   is (nRF51.RNG.Read);

end Micro_Gamer;
