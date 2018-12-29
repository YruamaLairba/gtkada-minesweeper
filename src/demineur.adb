with Gtk.Main; use Gtk.Main;

with P_Main_Window; use P_Main_Window;

procedure demineur is
begin
   Init;
   declare
      main_window : T_Main_Window;
      Game : T_Game;
   begin
      Game := new T_Game_Record'(
         Height => 10,
         Width => 10,
         Nb_Mine=> 10);
      Init_Main_Window(main_window, Game);
      Main;
      free(main_window);
      free(Game);
   end;
end demineur;
