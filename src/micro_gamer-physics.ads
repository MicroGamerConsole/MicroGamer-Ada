with HAL.Bitmap;

with Micro_Gamer.Maths_Types; use Micro_Gamer.Maths_Types;

package Micro_Gamer.Physics is

   type Hit_Box_Kind is (None, Rectangle, Rect_Borders, Circle, Line);

   type Hit_Box_Type (Kind : Hit_Box_Kind := Rectangle) is record
      case Kind is
         when None =>
            null;
         when Rectangle | Rect_Borders =>
            Width  : Length_Value;
            Height : Length_Value;
         when Circle =>
            Radius : Length_Value;
         when Line =>
            End_X_Offset : Length_Value;
            End_Y_Offset : Length_Value;
      end case;
   end record;

   type Object is tagged private;

   procedure Set_Hit_Box (This : in out Object; Box : Hit_Box_Type);
   function Hit_Box (This : Object) return Hit_Box_Type;

   function Collide (This : Object; Obj : Object'Class) return Boolean;

   function Mass (This : Object) return Mass_Value;
   procedure Set_Mass (This : in out Object;
                       M    : Mass_Value);

   function Position (This : Object) return Position_Type;
   procedure Set_Position (This : in out Object;
                           P    : Position_Type);

   function Speed (This : Object) return Speed_Vect;
   procedure Set_Speed (This : in out Object;
                        S    : Speed_Vect);

   function Acceleration (This : Object) return Acceleration_Vect;
   procedure Set_Acceleration (This : in out Object;
                               A    : Acceleration_Vect);

   function Force (This : Object) return Force_Vect;
   procedure Apply_Force (This : in out Object;
                          F    : Force_Vect);

   procedure Step (This    : in out Object;
                   Elapsed : Time_Value);

private

   type Object is tagged record
      Box : Hit_Box_Type := (Kind => None);
      P   : Position_Type := Origin;
      M   : Mass_Value := Mass_Value (0.0);
      S   : Speed_Vect := No_Speed;
      A   : Acceleration_Vect := No_Acceleration;
      F   : Force_Vect := No_Force;
   end record;

end Micro_Gamer.Physics;
