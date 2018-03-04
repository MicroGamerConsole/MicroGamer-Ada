with HAL;

package Micro_Gamer.Sound is

   type Note is range  0 .. 127
     with Size => 7;
   --  Note identifier, same range as the MIDI protocol

   subtype Note_Duration_Ms is HAL.UInt32;
   --  Note duration in milliseconds

   ------------
   -- Melody --
   ------------

   type Event_Kind is (Note_On, Wait);
   --  Melody event kind

   type Event (Kind : Event_Kind := Note_On) is record
      case Kind is
         when Note_On => N : Note;
         when Wait    => Duration : Note_Duration_Ms;
      end case;
   end record;
   --  Melody event, Note_On can be used to stop sound with the Silence Note

   type Melody is array (Natural range <>) of Event;
   --  A melody is defined as a series of event

   type Melody_Access is access constant Melody;

   procedure Play (N : Note);
   --  Play a single until stopped or replaced by a diffent note

   procedure Play (N : Note; Duration : Note_Duration_Ms);
   --  Play a single for Duration milliseconds or until stopped or replaced by a
   --  different note.

   procedure Play (M : not null Melody_Access; In_Loop : Boolean);
   --  Play a melody.
   --
   --  If In_Loop is true, the melody will loop until stopped by a call to
   --  Stop_Melody.
   --
   --  The melody array pointed by M must not be deallocated while the melody is
   --  playing.

   procedure Stop_Note;
   --  Stop the current note

   procedure Stop_Melody;
   --  Stop the current melody

   -----------
   -- Notes --
   -----------

   Silence : constant Note := 0;

private

   Prescaler : constant := 5;

   One_Sec : constant := (16_000_000.0 / (2**Prescaler));

   subtype Note_Frequency is HAL.UInt16;

   type Note_Array is array (Note) of Note_Frequency
     with Size => 16 * 128;

   Midi_To_Frequency : constant Note_Array :=
     (0   => Note_Frequency (One_Sec / 8.1757989156),
      1   => Note_Frequency (One_Sec / 8.6619572180),
      2   => Note_Frequency (One_Sec / 9.1770239974),
      3   => Note_Frequency (One_Sec / 9.7227182413),
      4   => Note_Frequency (One_Sec / 10.3008611535),
      5   => Note_Frequency (One_Sec / 10.9133822323),
      6   => Note_Frequency (One_Sec / 11.5623257097),
      7   => Note_Frequency (One_Sec / 12.2498573744),
      8   => Note_Frequency (One_Sec / 12.9782717994),
      9   => Note_Frequency (One_Sec / 13.7500000000),
      10  => Note_Frequency (One_Sec / 14.5676175474),
      11  => Note_Frequency (One_Sec / 15.4338531643),
      12  => Note_Frequency (One_Sec / 16.3515978313),
      13  => Note_Frequency (One_Sec / 17.3239144361),
      14  => Note_Frequency (One_Sec / 18.3540479948),
      15  => Note_Frequency (One_Sec / 19.4454364826),
      16  => Note_Frequency (One_Sec / 20.6017223071),
      17  => Note_Frequency (One_Sec / 21.8267644646),
      18  => Note_Frequency (One_Sec / 23.1246514195),
      19  => Note_Frequency (One_Sec / 24.4997147489),
      20  => Note_Frequency (One_Sec / 25.9565435987),
      21  => Note_Frequency (One_Sec / 27.5000000000),
      22  => Note_Frequency (One_Sec / 29.1352350949),
      23  => Note_Frequency (One_Sec / 30.8677063285),
      24  => Note_Frequency (One_Sec / 32.7031956626),
      25  => Note_Frequency (One_Sec / 34.6478288721),
      26  => Note_Frequency (One_Sec / 36.7080959897),
      27  => Note_Frequency (One_Sec / 38.8908729653),
      28  => Note_Frequency (One_Sec / 41.2034446141),
      29  => Note_Frequency (One_Sec / 43.6535289291),
      30  => Note_Frequency (One_Sec / 46.2493028390),
      31  => Note_Frequency (One_Sec / 48.9994294977),
      32  => Note_Frequency (One_Sec / 51.9130871975),
      33  => Note_Frequency (One_Sec / 55.0000000000),
      34  => Note_Frequency (One_Sec / 58.2704701898),
      35  => Note_Frequency (One_Sec / 61.7354126570),
      36  => Note_Frequency (One_Sec / 65.4063913251),
      37  => Note_Frequency (One_Sec / 69.2956577442),
      38  => Note_Frequency (One_Sec / 73.4161919794),
      39  => Note_Frequency (One_Sec / 77.7817459305),
      40  => Note_Frequency (One_Sec / 82.4068892282),
      41  => Note_Frequency (One_Sec / 87.3070578583),
      42  => Note_Frequency (One_Sec / 92.4986056779),
      43  => Note_Frequency (One_Sec / 97.9988589954),
      44  => Note_Frequency (One_Sec / 103.8261743950),
      45  => Note_Frequency (One_Sec / 110.0000000000),
      46  => Note_Frequency (One_Sec / 116.5409403795),
      47  => Note_Frequency (One_Sec / 123.4708253140),
      48  => Note_Frequency (One_Sec / 130.8127826503),
      49  => Note_Frequency (One_Sec / 138.5913154884),
      50  => Note_Frequency (One_Sec / 146.8323839587),
      51  => Note_Frequency (One_Sec / 155.5634918610),
      52  => Note_Frequency (One_Sec / 164.8137784564),
      53  => Note_Frequency (One_Sec / 174.6141157165),
      54  => Note_Frequency (One_Sec / 184.9972113558),
      55  => Note_Frequency (One_Sec / 195.9977179909),
      56  => Note_Frequency (One_Sec / 207.6523487900),
      57  => Note_Frequency (One_Sec / 220.0000000000),
      58  => Note_Frequency (One_Sec / 233.0818807590),
      59  => Note_Frequency (One_Sec / 246.9416506281),
      60  => Note_Frequency (One_Sec / 261.6255653006),
      61  => Note_Frequency (One_Sec / 277.1826309769),
      62  => Note_Frequency (One_Sec / 293.6647679174),
      63  => Note_Frequency (One_Sec / 311.1269837221),
      64  => Note_Frequency (One_Sec / 329.6275569129),
      65  => Note_Frequency (One_Sec / 349.2282314330),
      66  => Note_Frequency (One_Sec / 369.9944227116),
      67  => Note_Frequency (One_Sec / 391.9954359817),
      68  => Note_Frequency (One_Sec / 415.3046975799),
      69  => Note_Frequency (One_Sec / 440.0000000000),
      70  => Note_Frequency (One_Sec / 466.1637615181),
      71  => Note_Frequency (One_Sec / 493.8833012561),
      72  => Note_Frequency (One_Sec / 523.2511306012),
      73  => Note_Frequency (One_Sec / 554.3652619537),
      74  => Note_Frequency (One_Sec / 587.3295358348),
      75  => Note_Frequency (One_Sec / 622.2539674442),
      76  => Note_Frequency (One_Sec / 659.2551138257),
      77  => Note_Frequency (One_Sec / 698.4564628660),
      78  => Note_Frequency (One_Sec / 739.9888454233),
      79  => Note_Frequency (One_Sec / 783.9908719635),
      80  => Note_Frequency (One_Sec / 830.6093951599),
      81  => Note_Frequency (One_Sec / 880.0000000000),
      82  => Note_Frequency (One_Sec / 932.3275230362),
      83  => Note_Frequency (One_Sec / 987.7666025122),
      84  => Note_Frequency (One_Sec / 1046.5022612024),
      85  => Note_Frequency (One_Sec / 1108.7305239075),
      86  => Note_Frequency (One_Sec / 1174.6590716696),
      87  => Note_Frequency (One_Sec / 1244.5079348883),
      88  => Note_Frequency (One_Sec / 1318.5102276515),
      89  => Note_Frequency (One_Sec / 1396.9129257320),
      90  => Note_Frequency (One_Sec / 1479.9776908465),
      91  => Note_Frequency (One_Sec / 1567.9817439270),
      92  => Note_Frequency (One_Sec / 1661.2187903198),
      93  => Note_Frequency (One_Sec / 1760.0000000000),
      94  => Note_Frequency (One_Sec / 1864.6550460724),
      95  => Note_Frequency (One_Sec / 1975.5332050245),
      96  => Note_Frequency (One_Sec / 2093.0045224048),
      97  => Note_Frequency (One_Sec / 2217.4610478150),
      98  => Note_Frequency (One_Sec / 2349.3181433393),
      99  => Note_Frequency (One_Sec / 2489.0158697766),
      100 => Note_Frequency (One_Sec / 2637.0204553030),
      101 => Note_Frequency (One_Sec / 2793.8258514640),
      102 => Note_Frequency (One_Sec / 2959.9553816931),
      103 => Note_Frequency (One_Sec / 3135.9634878540),
      104 => Note_Frequency (One_Sec / 3322.4375806396),
      105 => Note_Frequency (One_Sec / 3520.0000000000),
      106 => Note_Frequency (One_Sec / 3729.3100921447),
      107 => Note_Frequency (One_Sec / 3951.0664100490),
      108 => Note_Frequency (One_Sec / 4186.0090448096),
      109 => Note_Frequency (One_Sec / 4434.9220956300),
      110 => Note_Frequency (One_Sec / 4698.6362866785),
      111 => Note_Frequency (One_Sec / 4978.0317395533),
      112 => Note_Frequency (One_Sec / 5274.0409106059),
      113 => Note_Frequency (One_Sec / 5587.6517029281),
      114 => Note_Frequency (One_Sec / 5919.9107633862),
      115 => Note_Frequency (One_Sec / 6271.9269757080),
      116 => Note_Frequency (One_Sec / 6644.8751612791),
      117 => Note_Frequency (One_Sec / 7040.0000000000),
      118 => Note_Frequency (One_Sec / 7458.6201842894),
      119 => Note_Frequency (One_Sec / 7902.1328200980),
      120 => Note_Frequency (One_Sec / 8372.0180896192),
      121 => Note_Frequency (One_Sec / 8869.8441912599),
      122 => Note_Frequency (One_Sec / 9397.2725733570),
      123 => Note_Frequency (One_Sec / 9956.0634791066),
      124 => Note_Frequency (One_Sec / 10548.0818212118),
      125 => Note_Frequency (One_Sec / 11175.3034058561),
      126 => Note_Frequency (One_Sec / 11839.8215267723),
      127 => Note_Frequency (One_Sec / 12543.8539514160));

end Micro_Gamer.Sound;
