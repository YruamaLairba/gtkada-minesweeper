
package body P_Main_Window is

   procedure Initialize(Main_Window : in out T_Main_Window) is
   begin
      Gtk_New(GTK_Window(Main_Window.Win),Window_Toplevel) ;
      Main_Window.Win.Set_Title("Demineur") ;
      Main_Window.Win.Show_All;
   end Initialize;

end P_Main_Window;

