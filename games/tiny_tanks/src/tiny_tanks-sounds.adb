with Micro_Gamer.Sound; use Micro_Gamer.Sound;

package body Tiny_Tanks.Sounds is

   Fire_Data : aliased Melody := (1 .. 40 => (Note_On, Silence));
   Explosion_Data : aliased Melody := (1 .. 20 => (Note_On, Silence));

   Rand : UInt32 := 5313;

   ----------
   -- Fire --
   ----------

   function Fire return not null Micro_Gamer.Sound.Melody_Access
   is (Fire_Data'Access);

   ---------------
   -- Explosion --
   ---------------

   function Explosion return not null Micro_Gamer.Sound.Melody_Access
   is (Explosion_Data'Access);

begin

   for Index in Fire_Data'Range loop
      Rand := 8253729 * Rand + 2396403;
      if Index mod 2 = 1 then
         Fire_Data (Index) := (Note_On, Note (Rand mod 128));
      else
         Fire_Data (Index) := (Wait, 10);
      end if;
   end loop;

   for Index in Explosion_Data'Range loop
      Rand := 8253729 * Rand + 2396403;
      if Index mod 2 = 1 then
         Explosion_Data (Index) := (Note_On, Note (Rand mod 30));
      else
         Explosion_Data (Index) := (Wait, 70);
      end if;
   end loop;

end Tiny_Tanks.Sounds;
