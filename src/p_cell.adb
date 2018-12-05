package body P_Cell is


   procedure Initialize (Cell: in out T_Cell) is
   begin
      Gtk_New(Cell.Button);
      Gtk_New(Cell.Image); --initialize a null image
      Cell.Button.Add(Cell.Image);
   end Initialize;

   procedure Clicked_Callback(
      Emetteur : access Gtk_Button_Record'class;
      Cell : T_Cell) is
   begin
      if Cell.Mined then
         Set(Cell.Image, "share/icons/mine-rouge.png");
      else
         Clear(Cell.Image);
      end if;
   end Clicked_Callback;

end P_Cell;
