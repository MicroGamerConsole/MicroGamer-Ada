with MicroBit;      use MicroBit;
with MicroBit.Time;
with nRF51.Device;
with nRF51.GPIO;
with nRF51.TWI;

with HAL.GPIO;

with SSD1306.Standard_Resolutions; use SSD1306.Standard_Resolutions;

package body Micro_Gamer is

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

   Init_Done : Boolean := False;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean
   is (Init_Done);

   ---------------
   -- Initalize --
   ---------------

   procedure Initalize
   is
      Unref : Boolean with Unreferenced;
   begin
      Unref := MB_P8.Set_Mode (HAL.GPIO.Output);

      for Btn of Button_Pins loop
         Unref := Btn.Set_Mode (HAL.GPIO.Input);
         Unref := Btn.Set_Pull_Resistor (HAL.GPIO.Pull_Up);
      end loop;

      Screen_I2C.Configure (SCL   => Screen_SCL_Pin.Pin,
                            SDA   => Screen_SDA_Pin.Pin,
                            Speed => nRF51.TWI.TWI_400kbps);
      Screen_I2C.Enable;
      Screen.Initialize (External_VCC => False);
      Screen.Initialize_Layer (Layer  => 1,
                               Mode   => HAL.Bitmap.M_1);
      Screen.Turn_On;

      Init_Done := True;
   end Initalize;

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
      Screen.Update_Layers;
   end Update;

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

   --------------
   -- Delay_Ms --
   --------------

   procedure Delay_Ms (Ms : HAL.UInt64) is
   begin
      MicroBit.Time.Delay_Ms (Ms);
   end Delay_Ms;

end Micro_Gamer;
