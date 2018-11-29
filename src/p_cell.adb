package body P_Cell is


   procedure Initialize (Cell: in out T_Cell) is
   begin
      Gtk_New(Cell.Button);
   end Initialize;

end P_Cell;
