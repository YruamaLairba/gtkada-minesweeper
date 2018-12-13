
package body P_Main_Window is

   procedure Stop_Program(Emetteur : access Gtk_Widget_Record'class) is
      pragma Unreferenced (Emetteur );
   begin
      Main_Quit;
   end Stop_Program ;

   procedure Initialize(Main_Window : in out T_Main_Window) is
   begin
      Main_Window.Game.Height := 10;
      Main_Window.Game.Width := 10;
      Main_Window.Game.Nb_Mine := 10;

      Gtk_New(GTK_Window(Main_Window.Win),Window_Toplevel) ;
      Main_Window.Win.Set_Title("Demineur");
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
            Initialize(Main_Window.Cells(row, col));
            Main_Window.Table.Attach(
               --Main_Window.Table,
               Main_Window.Cells(row,col).Button,
               Guint(col-1),
               Guint(col),
               Guint(row-1),
               Guint(row));

            Connect(
               Main_Window.Cells(row,col).Button,
               "button_press_event",
               To_Marshaller(Cell_Clicked_Callback'access),
               Main_Window.Cells(row,col));
         end loop;
      end loop;

      Main_Window.Win.Add(Main_Window.Table);

      Connect(Main_Window.Win, "destroy", Stop_Program'access) ;

      Main_Window.Win.Show_All;
   end Initialize;

   function Cell_Clicked_Callback(
      Emetteur : access Gtk_Button_Record'class;
      Event : GDK_Event;
      Cell: T_Cell) return Boolean is
      No_Animation : Boolean := Cell.State/=Normal;
   begin
      case Get_Button(Event) is
         --left click
         when 1 => Dig(Cell);
         --right click
         when 3 => Flag(Cell);
         when others => null;
      end case;
      --left click animation only when state is normal
      return No_Animation ;
   end Cell_Clicked_Callback;

end P_Main_Window;

