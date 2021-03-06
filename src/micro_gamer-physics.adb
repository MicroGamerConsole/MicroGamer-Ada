package body Micro_Gamer.Physics is

   function Collide_Rect_Rect (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Rectangle,
     Inline;

   function Collide_Rect_Borders (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Rect_Borders,
     Inline;

   function Collide_Rect_Circle (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Circle,
     Inline;

   function Collide_Rect_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Line,
     Inline;

   function Collide_Borders_Borders (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rect_Borders and then B.Box.Kind = Rect_Borders,
     Inline;

   function Collide_Borders_Circle (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rect_Borders and then B.Box.Kind = Circle,
     Inline;

   function Collide_Borders_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rect_Borders and then B.Box.Kind = Line,
     Inline;

   function Collide_Circle_Circle (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Circle and then B.Box.Kind = Circle,
     Inline;

   function Collide_Circle_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Circle and then B.Box.Kind = Line,
     Inline;

   function Collide_Line_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Line and then B.Box.Kind = Line,
     Inline;

   -----------------
   -- Set_Hit_Box --
   -----------------

   procedure Set_Hit_Box (This : in out Object; Box : Hit_Box_Type) is
   begin
      This.Box := Box;
   end Set_Hit_Box;

   -------------
   -- Hit_Box --
   -------------

   function Hit_Box (This : Object) return Hit_Box_Type
   is (This.Box);

   -----------------------
   -- Collide_Rect_Rect --
   -----------------------

   function Collide_Rect_Rect (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Rect;

   --------------------------
   -- Collide_Rect_Borders --
   --------------------------

   function Collide_Rect_Borders (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Borders;

   -------------------------
   -- Collide_Rect_Circle --
   -------------------------

   function Collide_Rect_Circle (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Circle;

   -----------------------
   -- Collide_Rect_Line --
   -----------------------

   function Collide_Rect_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Line;

   -----------------------------
   -- Collide_Borders_Borders --
   -----------------------------

   function Collide_Borders_Borders (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Borders_Borders;

   ----------------------------
   -- Collide_Borders_Circle --
   ----------------------------

   function Collide_Borders_Circle (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Borders_Circle;

   --------------------------
   -- Collide_Borders_Line --
   --------------------------

   function Collide_Borders_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Borders_Line;

   ---------------------------
   -- Collide_Circle_Circle --
   ---------------------------

   function Collide_Circle_Circle (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Circle_Circle;

   -------------------------
   -- Collide_Circle_Line --
   -------------------------

   function Collide_Circle_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Circle_Line;

   -----------------------
   -- Collide_Line_Line --
   -----------------------

   function Collide_Line_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Line_Line;

   -------------
   -- Collide --
   -------------

   function Collide (This : Object; Obj : Object'Class) return Boolean is
   begin
      case This.Box.Kind is
         when None =>
            return False;
         when Rectangle =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Rect (This, Obj);
            when Rect_Borders =>
               return Collide_Rect_Borders (This, Obj);
            when Circle =>
               return Collide_Rect_Circle (This, Obj);
            when Line =>
               return Collide_Rect_Line (This, Obj);
            end case;
         when Rect_Borders =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Borders (Obj, This);
            when Rect_Borders =>
               return Collide_Borders_Borders (This, Obj);
            when Circle =>
               return Collide_Borders_Circle (This, Obj);
            when Line =>
               return Collide_Borders_Line (This, Obj);
            end case;
         when Circle =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Circle (Obj, This);
            when Rect_Borders =>
               return Collide_Borders_Circle (Obj, This);
            when Circle =>
               return Collide_Circle_Circle (This, Obj);
            when Line =>
               return Collide_Circle_Line (This, Obj);
            end case;
         when Line =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Line (Obj, This);
            when Rect_Borders =>
               return Collide_Borders_Line (Obj, This);
            when Circle =>
               return Collide_Circle_Line (Obj, This);
            when Line =>
               return Collide_Line_Line (This, Obj);
            end case;
      end case;
   end Collide;

   ----------
   -- Mass --
   ----------

   function Mass (This : Object) return Mass_Value
   is (This.M);

   --------------
   -- Set_Mass --
   --------------

   procedure Set_Mass (This : in out Object;
                       M    : Mass_Value)
   is
   begin
      This.M := M;
   end Set_Mass;

   --------------
   -- Position --
   --------------

   function Position (This : Object) return Position_Type
   is (This.P);

   ------------------
   -- Set_Position --
   ------------------

   procedure Set_Position
     (This : in out Object;
      P    : Position_Type)
   is
   begin
      This.P := P;
   end Set_Position;

   -----------
   -- Speed --
   -----------

   function Speed (This : Object) return Speed_Vect
   is (This.S);

   ---------------
   -- Set_Speed --
   ---------------

   procedure Set_Speed
     (This : in out Object;
      S    : Speed_Vect)
   is
   begin
      This.S := S;
   end Set_Speed;


   ------------------
   -- Acceleration --
   ------------------

   function Acceleration (This : Object) return Acceleration_Vect
   is (This.A);

   ----------------------
   -- Set_Acceleration --
   ----------------------

   procedure Set_Acceleration
     (This : in out Object;
      A    : Acceleration_Vect)
   is
   begin
      This.A := A;
   end Set_Acceleration;

   -----------
   -- Force --
   -----------

   function Force (This : Object) return Force_Vect
   is (This.F);

   -----------------
   -- Apply_Force --
   -----------------

   procedure Apply_Force
     (This : in out Object;
      F    : Force_Vect)
   is
   begin
      This.F.X := This.F.X + F.X;
      This.F.Y := This.F.Y + F.Y;
   end Apply_Force;

   ----------
   -- Step --
   ----------

   procedure Step
     (This    : in out Object;
      Elapsed : Time_Value)
   is
   begin
      This.A.X := This.F.X / This.M;
      This.A.Y := This.F.Y / This.M;
      This.F := No_Force;

      This.S.X := This.S.X + This.A.X * Elapsed;
      This.S.Y := This.S.Y + This.A.Y * Elapsed;

      This.P.X := This.P.X + This.S.X * Elapsed;
      This.P.Y := This.P.Y + This.S.Y * Elapsed;
   end Step;

end Micro_Gamer.Physics;
