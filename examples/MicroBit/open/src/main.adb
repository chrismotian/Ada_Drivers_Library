with MicroBit.IOs; use MicroBit.IOs;
with MicroBit.Time; use MicroBit.Time;
with HAL;      use HAL;
with NeoPixel; use NeoPixel;
with LED_Demo; use LED_Demo;


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

   -- LED can be controlled with all colors
   Strip : LED_Strip := Create (Mode => GRB, Count => 18);
   myColorValues : LED_Values := (LED_Green => 255,LED_Red => 255,LED_Blue=>255,LED_White=>255);
   goalColorValues : LED_Values := (LED_Green => 255,LED_Red => 255,LED_Blue=>255,LED_White=>255);

   dialValueColor : Analog_Value;
   dialGoalColor : Analog_Value;

begin

   -- Turn on the LED connected to pin 0
   Set (0, True);

   -- Hardcoded "random" choice
   dialGoal := 100;
   -- The input needs to be adjusted because the conditional statement is made from red to red but I want red to purple
   dialGoalColor := dialGoal*5/6;
   
   if dialGoalColor < 341 then
      dialGoalColor := (dialGoalColor*3)/4;
      goalColorValues := (LED_Green => UInt8(dialGoalColor),LED_Red => 255 - UInt8(dialGoalColor),LED_Blue=>0,LED_White=>100);
   elsif dialGoalColor < 682 then
      dialGoalColor := ((dialGoalColor-341)*3)/4;
      goalColorValues := (LED_Blue => UInt8(dialGoalColor),LED_Green => 255 - UInt8(dialGoalColor),LED_Red=>0,LED_White=>100);
   else
      dialGoalColor := ((dialGoalColor-683)*3)/4;
      goalColorValues := (LED_Red => UInt8(dialGoalColor),LED_Blue => 255 - UInt8(dialGoalColor),LED_Green=>0,LED_White=>100);
   end if;

   -- color can be changed for each LED individually
   Set_Color (Strip, 0, myColorValues);
   Set_Color (Strip, 7, goalColorValues);
   -- change color command
   Show (Strip, Kitronik_Write'Access);

   countTimeUInt64 := UInt64(countTime);
   --  lockLight is lighted up until the potentiometer is on the goal position.The Color on the Strip has to be changed at least one's
   while countTimeUInt64 < UInt64(Clock)+bootTime loop

      -- Reading the potentiometer
      dialValue := Analog(1);
      dialValueColor := dialValue*5/6;

      if dialValueColor < 341 then
         dialValueColor := (dialValueColor*3)/4;
         myColorValues := (LED_Green => UInt8(dialValueColor),LED_Red => 255 - UInt8(dialValueColor),LED_Blue=>0,LED_White=>100);
      elsif dialValueColor < 682 then
         dialValueColor := ((dialValueColor-341)*3)/4;
         myColorValues := (LED_Blue => UInt8(dialValueColor),LED_Green => 255 - UInt8(dialValueColor),LED_Red=>0,LED_White=>100);
      else
         dialValueColor := ((dialValueColor-683)*3)/4;
         myColorValues := (LED_Red => UInt8(dialValueColor),LED_Blue => 255 - UInt8(dialValueColor),LED_Green=>0,LED_White=>100);
      end if;

      Set_Color (Strip, 0, myColorValues);
      Show (Strip, Kitronik_Write'Access);

      exit when dialValue = dialGoal;
   end loop;
   --  game won
   Set (0, False);
   --  the program restarts if the program ends and therefore we include an empty infinite loop after we've won
   loop

      null;

   end loop;
end Main;
