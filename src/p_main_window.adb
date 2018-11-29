
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

      Main_Window.Win.Add(Main_Window.Cell.Button);

      Connect(Main_Window.Win, "destroy", Stop_Program'access) ;
      Main_Window.Win.Show_All;
   end Initialize;

end P_Main_Window;

