with Gtk.Main; use Gtk.Main;

with P_Main_Window; use P_Main_Window;

procedure demineur is
begin
   Init;
   declare
      main_window : T_Main_Window;
   begin
      Main;
   end;
end demineur;
