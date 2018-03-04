with HAL;                         use HAL;
with nRF51.Device;                use nRF51.Device;
with nRF51.Timers;                use nRF51.Timers;
with nRF51.GPIO.Tasks_And_Events; use nRF51.GPIO.Tasks_And_Events;
with nRF51.PPI;
with nRF51.Tasks;

with MicroBit;
with MicroBit.Time;

package body Micro_Gamer.Sound is

   Buzzer : nRF51.GPIO.GPIO_Point renames MicroBit.MB_P0;

   End_Of_Wait      : UInt32  := UInt32'Last with Atomic;

   The_Melody           : Melody_Access := null;
   Current_Melody_Index : Natural := 0;
   Last_Melody_Index    : Natural := 0;
   Now_Playing_Melody   : Boolean := False with Atomic;
   Looping_Melody       : Boolean := False;

   procedure Initialize;

   procedure Process_Events;
   --  Process events in the current melody until a wait event or the end of the
   --  melody.

   procedure Timer_Tick_Ms;
   --  Called avery milliseconds by the time handling package

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Unref : Boolean with Unreferenced;
   begin
      Timer_0.Set_Mode (Mode_Timer);
      Timer_0.Set_Prescaler (Prescaler);
      Timer_0.Set_Bitmode (Bitmode_32bit);

      --  Clear counter internal register when timer reaches compare 0 value.
      --  We do not stop the timer.
      Timer_0.Compare_Shortcut (Chan  => 0,
                                Stop  => False,
                                Clear => True);

      --  When timer compare event is triggerd GPTIOTE OUT 0 task will be
      --  activated.
      nRF51.PPI.Configure (Chan    => 0,
                           Evt_EP  => Timer_0.Compare_Event (0),
                           Task_EP => nRF51.Tasks.GPIOTE_OUT_0);
      nRF51.PPI.Enable_Channel (Chan => 0);

      --  Configure the GPIOTE OUT 0 task to toggle the pin
      nRF51.GPIO.Tasks_And_Events.Enable_Task (Chan          => 0,
                                               GPIO_Pin      => Buzzer.Pin,
                                               Action        => Toggle_Pin,
                                               Initial_Value => Init_Clear);


      if not MicroBit.Time.Tick_Subscribe (Timer_Tick_Ms'Access) then
         raise Program_Error;
      end if;
   end Initialize;

   --------------------
   -- Process_Events --
   --------------------

   procedure Process_Events is
      Done : Boolean := False;
   begin
      loop
         declare
            Evt  : Event renames The_Melody (Current_Melody_Index);
         begin
            case Evt.Kind is
            when Wait =>
               End_Of_Wait := UInt32 (Clock_Ms) + Evt.Duration;
               Done := True;
            when Note_On =>
               Play (Evt.N);
            end case;
         end;

         if Current_Melody_Index < Last_Melody_Index then
            Current_Melody_Index := Current_Melody_Index + 1;
         elsif Looping_Melody then
            Current_Melody_Index := The_Melody'First;
         else
            Now_Playing_Melody := False;
            Done := True;
         end if;

         exit when Done;
      end loop;
   end Process_Events;

   -------------------
   -- Timer_Tick_Ms --
   -------------------

   procedure Timer_Tick_Ms is
      Now : constant UInt32 :=  UInt32 (Clock_Ms);
   begin
      if End_Of_Wait < Now then
         if Now_Playing_Melody then
            Process_Events;
         else
            Stop_Note;
         end if;
      end if;
   end Timer_Tick_Ms;

   ----------
   -- Play --
   ----------

   procedure Play (N : Note) is
   begin
      Stop_Note;
      if N /= Silence then
         Timer_0.Clear;
         Timer_0.Set_Compare (0, UInt32 (Midi_To_Frequency (N)));
         Timer_0.Start;
      end if;
   end Play;

   ----------
   -- Play --
   ----------

   procedure Play (N : Note; Duration : HAL.UInt32) is
   begin
      Play (N);
      End_Of_Wait := UInt32 (Clock_Ms) + Duration;
   end Play;

   ----------
   -- Play --
   ----------

   procedure Play (M : not null Melody_Access; In_Loop : Boolean) is
   begin
      --  Stop the current meoldy, if any
      Stop_Melody;

      --  Set the index of the first note in melody
      Current_Melody_Index := M'First;

      --  Set the index of the last note in melody
      Last_Melody_Index := M'Last;

      The_Melody := M;

      --  Start playing the melody
      Looping_Melody := In_Loop;
      Now_Playing_Melody := True;

      End_Of_Wait := 0;
   end Play;

   ---------------
   -- Stop_Note --
   ---------------

   procedure Stop_Note is
   begin
      End_Of_Wait := UInt32'Last;
      Timer_0.Stop;
   end Stop_Note;

   -----------------
   -- Stop_Melody --
   -----------------

   procedure Stop_Melody is
   begin
      Now_Playing_Melody := False;
      Stop_Note;
   end Stop_Melody;

begin
   Initialize;
end Micro_Gamer.Sound;
