with HAL;                     use HAL;
with System.Storage_Elements; use System.Storage_Elements;
with NRF51_SVD.NVMC;          use NRF51_SVD.NVMC;

package body Micro_Gamer.Memory_Card is

--     Flash_Data : Data_Type with Address => To_Address (1024 * 255);

   Flash_Data : Data_Type;
   pragma Import (C, Flash_Data, "__memory_card_flash_data");

   ----------
   -- Load --
   ----------

   procedure Load
   is
   begin
      Data := Flash_Data;
   end Load;

   ----------
   -- Save --
   ----------

   procedure Save
   is
   begin

      while NVMC_Periph.READY.READY = Busy loop
         null;
      end loop;

      --  Enable erase
      NVMC_Periph.CONFIG.WEN := Een;

      --  Erase flash page
      NVMC_Periph.ERASEPCR1 := UInt32 (To_Integer (Flash_Data'Address));

      while NVMC_Periph.READY.READY = Busy loop
         null;
      end loop;

      --  Enable write
      NVMC_Periph.CONFIG.WEN := Wen;

      --  Write flash page
      Flash_Data := Data;

      while NVMC_Periph.READY.READY = Busy loop
         null;
      end loop;

      --  Disable write
      NVMC_Periph.CONFIG.WEN := Ren;
   end Save;

end Micro_Gamer.Memory_Card;
