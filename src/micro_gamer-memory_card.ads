generic
   type Data_Type is private;
package Micro_Gamer.Memory_Card is

   Data : Data_Type;

   pragma Compile_Time_Error (Data'Size > 1024 * 8,
                              "Data_Type does not fit in one flash page");
   pragma Compile_Time_Error (Data'Size mod 32 /= 0,
                              "Data_Type does not fit in one flash page:");

   type Data_Access is access all Data_Type;

   procedure Load;
   --  Load the data from persistant storage to the RAM

   procedure Save;
   --  Save the data from RAM to the persistant storage

end Micro_Gamer.Memory_Card;
