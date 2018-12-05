package body P_Cell is


   procedure Initialize (Cell: in out T_Cell) is
   begin
      Gtk_New(Cell.Button);
      --Gtk_New(Cell.Image); --initialize a null image
      Cell.Button.Set_Image(Gtk_Image_New);
   end Initialize;

   procedure Clicked_Callback(
      Emetteur : access Gtk_Button_Record'class;
      Cell : T_Cell) is
   begin
      if Cell.Mined then
         Set_Label(Cell.Button,"");
         Cell.Button.Set_Image(
            Gtk_Image_New_From_File("share/icons/mine-rouge.png"));
         --Set(Cell.Image, "share/icons/mine-rouge.png");
         --Cell.Button.Set_Image(Cell.Image);
      else
         if Cell.Nb_Foreign_Mine = 0 then
            Set_Label(Cell.Button,"");
         else
            Set_Label(Cell.Button, Natural'Image(Cell.Nb_Foreign_Mine));
         end if;
         Cell.Button.Set_Image(Gtk_Image_New);
         --Clear(Cell.Image);
      end if;
   end Clicked_Callback;

end P_Cell;
