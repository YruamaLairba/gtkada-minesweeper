
package body P_Main_Window is

   procedure Stop_Program(Emetteur : access Gtk_Widget_Record'class) is
      pragma Unreferenced (Emetteur );
   begin
      Main_Quit;
   end Stop_Program ;

   procedure Initialize(
      Main_Window : in out T_Main_Window_Record;
      Game: T_Game) is
      Frame1 : Gtk_Frame := Gtk_Frame_New;
   begin
      Main_Window.Game := Game;
      Main_Window.Game.Nb_Unmined_Cell := Game.Height * Game.Width -
         Game.Nb_Mine;

      Gtk_New(GTK_Window(Main_Window.Win),Window_Toplevel) ;
      Main_Window.Win.Set_Title("Demineur");

      Gtk_New_Vbox(Main_Window.Vbox);

      Gtk_New(Main_Window.Counter,"Cnt");

      Gtk_New(
         Main_Window.Table,
         Guint(Main_Window.Game.Height),
         Guint(Main_Window.Game.Width),
         true);

      Main_Window.Cells := new T_Cell_Tab(
         1..Main_Window.Game.Height,
         1..Main_Window.Game.Width);

      for row in Main_Window.Cells'Range(1) loop
         for col in Main_Window.Cells'Range(2) loop
            Init_Cell(Main_Window.Cells(row, col));
            Main_Window.Table.Attach(
               --Main_Window.Table,
               Main_Window.Cells(row,col).Alignment,
               Guint(col-1),
               Guint(col),
               Guint(row-1),
               Guint(row));
         end loop;
      end loop;

      Main_Window.Place_Mines(Main_Window.Game.Nb_Mine);
      --counting foreign mine for each mine;
      --for row in Main_Window.Cells'Range(1) loop
      --   for col in Main_Window.Cells'Range(2) loop
      --      declare
      --         nb_foreign_mine : natural :=0;
      --         f_row_first : natural := (
      --            if row = Main_Window.Cells'first then row else row-1);
      --         f_row_last : natural := (
      --            if row = Main_Window.Cells'last then row else row+1);
      --         f_col_first : natural := (
      --            if col = Main_Window.Cells'first then col else col-1);
      --         f_col_last : natural := (
      --            if col = Main_Window.Cells'last then col else col+1);
      --      begin
      --         for f_row in f_row_first..f_row_last loop
      --            for f_col in f_col_first..f_col_last loop
      --               if Main_Window.Cells(f_row,f_col).Mined then
      --                  nb_foreign_mine := nb_foreign_mine + 1;
      --               end if;
      --            end loop;
      --         end loop;
      --         Main_Window.Cells(row,col).Nb_Foreign_Mine := nb_foreign_mine;
      --      end;
      --   end loop;
      --end loop;

      --Main_Window.Vbox.Pack_Start(
      --   Child => Main_Window.Counter,
      --   Padding=>16);
      Frame1.Add(Main_Window.Counter);
      Main_Window.Vbox.Pack_Start(
         Child => Frame1,
         Padding=> 0);
      Main_Window.Vbox.Pack_Start(Main_Window.Table);
      Main_Window.Win.Add(Main_Window.Vbox);

      Connect(Main_Window.Win, "destroy", Stop_Program'access) ;

      Main_Window.Win.Show_All;
   end Initialize;

   procedure Init_Main_Window(
      Main_Window: in out T_Main_Window;
      Game: T_Game) is
   begin
      Main_Window := new T_Main_Window_Record;
      Main_Window.Initialize(Game);
      Main_Window.Set_Nb_Mine(Game.Nb_Mine);
      for row in Main_Window.Cells'Range(1) loop
         for col in Main_Window.Cells'Range(2) loop
            --Initialize(Main_Window.Cells(row, col));
            --Main_Window.Table.Attach(
            --   --Main_Window.Table,
            --   Main_Window.Cells(row,col).Alignment,
            --   Guint(col-1),
            --   Guint(col),
            --   Guint(row-1),
            --   Guint(row));
            Connect(
               Main_Window.all.Cells(row,col).Button,
               "button_press_event",
               To_Marshaller(Cell_Clicked_Callback'access),
               T_Cell_Callback_Data'(Main_Window,Row,Col));
         end loop;
      end loop;
   end Init_Main_Window;

   procedure Finalize(Main_Window : in out T_Main_Window_Record) is
   begin
      for row in Main_Window.Cells'Range(1) loop
         for col in Main_Window.Cells'Range(2) loop
            free(Main_Window.Cells(row,col));
         end loop;
      end loop;
      free(Main_Window.Cells);
   end Finalize;

   procedure Set_Nb_Mine(
      Main_Window : in out T_Main_Window_Record;
      Nb_Mine: Natural) is
   begin
      Main_Window.Game.Nb_Mine := Nb_Mine;
      Main_Window.Counter.Set_Label(Natural'Image(Nb_Mine));
   end;

   procedure Place_Mine(
      Main_Window: in out T_Main_Window_Record;
      row: Natural;
      col: Natural) is
      First_Row : Natural :=
         (if Row=Main_Window.Cells'first(1)
         then Main_Window.Cells'first(1) else row-1);
      Last_Row : Natural :=
         (if Row=Main_Window.Cells'last(1)
         then Main_Window.Cells'last(1) else row+1);
      First_Col : Natural :=
         (if Col=Main_Window.Cells'first(2)
         then Main_Window.Cells'first(2) else col-1);
      Last_Col : Natural :=
         (if Col=Main_Window.Cells'last(2)
         then Main_Window.Cells'last(2) else col+1);
   begin
      Main_Window.Cells(row,col).Mined :=True;
      for R in First_Row..Last_Row loop
         for C in First_Col..Last_Col loop
            Main_Window.Cells(R,C).Nb_Foreign_Mine :=
               Main_Window.Cells(R,C).Nb_Foreign_Mine +1;
         end loop;
      end loop;
   end Place_Mine;

   procedure Place_Mines(
      Main_Window: in out T_Main_Window_Record;
      Nb_Mine: Natural) is
      Gen : Generator;
      row: Natural;
      Col: Natural;
      Mult_R: Float := Float(
         Main_Window.Cells'Last(1) - Main_Window.Cells'First(1));
      Mult_C: Float := Float(
         Main_Window.Cells'Last(2) - Main_Window.Cells'First(2));
      Add_R: Float := Float(Main_Window.Cells'First(1));
      Add_C: Float := Float(Main_Window.Cells'First(2));
   begin
      Reset(Gen);
      for M in 1..Nb_Mine loop
         loop
            row := Natural(Random(Gen) * Mult_R + Add_R);
            col := Natural(Random(Gen) * Mult_C + Add_C);
            exit when not Main_Window.Cells(Row, Col).Mined;
         end loop;
         Place_Mine(Main_Window, row, col);
      end loop;
   end Place_Mines;

   procedure Dig_Around(
      Main_Window: in out T_Main_Window_Record;
      Row : Natural;
      Col : Natural) is
      Cells : access T_Cell_Tab := Main_window.Cells;
      First_Row : Natural :=
         (if Row=Cells'first(1) then Cells'first(1) else row-1);
      Last_Row : Natural :=
         (if Row=Cells'last(1) then Cells'last(1) else row+1);
      First_Col : Natural :=
         (if Col=Cells'first(2) then Cells'first(2) else col-1);
      Last_Col : Natural :=
         (if Col=Cells'last(2) then Cells'last(2) else col+1);
      Cell : T_Cell;
   begin
      Cell := Main_Window.Cells(Row, Col);
      if Cell.State = Normal then
         Cell.Dig;
         if Cell.Mined then
            Put_Line("Perdu");
            return;
         end if;
         Main_window.Game.Nb_Unmined_Cell :=
            Main_window.Game.Nb_Unmined_Cell - 1;
         if Main_window.Game.Nb_Unmined_Cell = 0 then
            Put_Line("Gagné");
            Win(Main_Window);
            return;
         end if;
      end if;
      if Cell.Nb_Foreign_Mine = 0 then
         for R in First_Row..Last_Row loop
            for C in First_Col..Last_Col loop
               Cell := Main_Window.Cells(R,C);
               if Cell.State = Normal  then
                  Dig_Around(Main_Window, R, C);
               end if;
            end loop;
         end loop;
      end if;
   end Dig_Around;

   procedure Win(Main_Window: in out T_Main_Window_Record) is
      Message_Win : Gtk_Window;
      Box : Gtk_Vbox;
      Lbl : Gtk_Label;
      Btn : Gtk_Button;
   begin
      Gtk_New(Message_Win);
      Message_Win.Set_Transient_For(Main_Window.Win);
      Gtk_New_Vbox(Box);
      Message_win.Add(Box);
      Gtk_New(Lbl, "You win!");
      Box.Pack_Start(Lbl);
      Gtk_New(Btn, "Ok");
      P_Message_Ok_URHandlers.Connect(
         Btn,
         "clicked",
         Message_Ok_Callback'access,
         Message_Win);
      Box.Pack_Start(Btn);
      Message_Win.Show_All;
   end Win;

   procedure Message_Ok_Callback(
      Emitter : access Gtk_Button_Record'Class;
      Message_Win : Gtk_Window) is
   begin
      Message_Win.Destroy;
   end Message_Ok_Callback;

   function Cell_Clicked_Callback(
      Emetteur : access Gtk_Button_Record'class;
      Event : GDK_Event;
      Data: T_Cell_Callback_Data) return Boolean is
      Row : Natural := Data.Row;
      Col : Natural := Data.Col;
      Cell : T_Cell := Data.Main_Window.Cells(Row,Col);
      No_Animation : Boolean := Cell.State/=Normal;
   begin
      case Get_Button(Event) is
         --left click
         when 1 =>
            Data.Main_Window.Dig_Around(Row, Col);
         --right click
         when 3 =>
            case Cell.State is
               when Normal =>
                  if Data.Main_Window.Game.Nb_Mine > 0 then
                     Cell.Flag;
                     Data.Main_Window.Set_Nb_Mine(
                        Data.Main_Window.Game.Nb_Mine - 1);
                  end if;
               when Flagged =>
                  Cell.Unflag;
                  Data.Main_Window.Set_Nb_Mine(
                     Data.Main_Window.Game.Nb_Mine + 1);
               when others => null;
            end case;
         when others => null;
      end case;
      --left click animation only when state is normal
      return No_Animation ;
   end Cell_Clicked_Callback;

end P_Main_Window;

