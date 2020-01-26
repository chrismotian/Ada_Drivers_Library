with MicroBit.IOs; use MicroBit.IOs;
with MicroBit.Time; use MicroBit.Time;
with HAL;      use HAL;

-- goal is to program a light which will be used to substitute a real locking system
-- real locking system could be a servo
-- turned on light is same as a locked lock

procedure Main is

   -- this is necessary to limit the idle;
    countTime : Time_Ms := Clock;
   -- this is necessary to make the variable above comparable;
   countTimeUInt64 : UInt64;
   -- this is necessary to make the counter and current time/Clock unequal at start
   bootTime : constant UInt64 := 10000;

   -- both are needed to have the current position and the goal for the potentiometer
   dialValue : Analog_Value;
   dialGoal : Analog_Value;

begin

   -- Turn on the LED connected to pin 0
   Set (0, True);

   dialValue := Analog(1);
   -- Hardcoded "random" choice
   dialGoal := 100;

   countTimeUInt64 := UInt64(countTime);
   --  lockLight is lighted up until the potentiometer is on the goal position
   while countTimeUInt64 < UInt64(Clock)+bootTime and dialValue /= dialGoal loop

      dialValue := Analog(1);

   end loop;
   --  game won
   Set (0, False);
   --  the program restarts if the program ends and therefore we include an empty infinite loop after we've won
   loop

      null;

   end loop;
end Main;
