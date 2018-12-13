
package body P_Main_Window is

   procedure Stop_Program(Emetteur : access Gtk_Widget_Record'class) is
      pragma Unreferenced (Emetteur );
   begin
      Main_Quit;
   end Stop_Program ;

   procedure Initialize(Main_Window : in out T_Main_Window) is
   begin
      Gtk_New(GTK_Window(Main_Window.Win),Window_Toplevel) ;
      Main_Window.Win.Set_Title("Demineur");
      Gtk_New_Hbox(Main_Window.Box);

      Initialize(Main_Window.Cell1);
      Initialize(Main_Window.Cell2);
      
      Main_Window.Cell1.Mined := true;
      Main_Window.Cell2.Nb_Foreign_Mine := 5;
      
      Main_Window.Box.Pack_Start(
         Main_Window.Cell1.Button,
         Expand=>true);
      Main_Window.Box.Pack_Start(
         Main_Window.Cell2.Button,
         Expand=>true);
      Main_Window.Win.Add(Main_Window.Box);

      Connect(Main_Window.Win, "destroy", Stop_Program'access) ;

      Connect(
         Main_Window.Cell1.Button,
         "button_press_event",
         To_Marshaller(Cell_Clicked_Callback'access),
         Main_Window.Cell1) ;

      Connect(
         Main_Window.Cell2.Button,
         "button_press_event",
         To_Marshaller(Cell_Clicked_Callback'access),
         Main_Window.Cell2) ;

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

