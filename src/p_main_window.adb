
package body P_Main_Window is

   procedure Stop_Program_Callback(
      Emetteur : access Gtk_Window_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.Win.Destroy;
      Main_Quit;
   end Stop_Program_Callback ;

   procedure Init(
      Main_Window : not null access T_Main_Window_Record;
      Height: Natural;
      Width : Natural;
      Nb_Mine: Natural) is
      Frame1 : Gtk_Frame := Gtk_Frame_New;
      ScrollWin: Gtk_Scrolled_Window;
      Menu_Bar : Gtk_Menu_Bar;
      Menu_Game : Gtk_Menu;
      Menu_Item_Game : Gtk_Menu_Item;
      Menu_Item_New : Gtk_Image_Menu_Item;
      Menu_Item_Beginner_Game : Gtk_Menu_Item;
      Menu_Item_Advanced_Game : Gtk_Menu_Item;
      Menu_Item_Expert_Game : Gtk_Menu_Item;
      Menu_Item_Custom_Game : Gtk_Menu_Item;
      Menu_Item_Style : Gtk_Image_Menu_Item;
      Menu_Item_Quit : Gtk_Image_Menu_Item;
      Menu_Help : Gtk_Menu;
      Menu_Item_Help : Gtk_Menu_Item;
      Menu_Item_About : Gtk_Image_Menu_Item;
   begin
      --Constraint Check
      if Height < 1 then
         raise CONSTRAINT_ERROR with "Bad height, minimum value is 1" ;
      end if;
      if Width < 1 then
         raise CONSTRAINT_ERROR with "Bad width, minimum value is 1" ;
      end if;
      if Nb_Mine > (Height * Width) then
         raise CONSTRAINT_ERROR with "Too many mines or too small grid" ;
      end if;
      --filling game data
      Main_Window.Height := Height;
      Main_Window.Width := Width;
      Main_Window.Nb_Mine := Nb_Mine;
      Main_Window.Nb_Flag := Nb_Mine;
      Main_Window.Nb_Unmined_Cell := Height * Width - Nb_Mine;
      --Create and build gui object
      Gtk_New(GTK_Window(Main_Window.Win),Window_Toplevel) ;
      Main_Window.Win.Set_Title("Minesweeper");

      Menu_Bar := Gtk_Menu_Bar_New;
      Menu_Bar.set_pack_direction(Pack_Direction_LTR) ;

      Menu_Item_Game := Gtk_Menu_Item_New_With_Label("Game");
      Menu_Bar.Append(Menu_Item_Game);

      Menu_Game := Gtk_Menu_New;
      Menu_Item_Game.Set_Submenu(Menu_Game);

      Menu_Item_New := Gtk_Image_Menu_Item_New_From_Stock(
         "gtk-new",
         null);
      Menu_Item_New.Set_Label("New");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_New,
         "activate",
         New_Game_Callback'access,
         Main_Window);

      Menu_Game.Append(Menu_Item_New);

      Menu_Game.Append(Gtk_Separator_Menu_Item_New);

      Menu_Item_Beginner_Game := Gtk_Menu_Item_New_With_Label("Beginner");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_Beginner_Game,
         "activate",
         Beginner_Game_Callback'access,
         Main_Window);
      Menu_Game.Append(Menu_Item_Beginner_Game);

      Menu_Item_Advanced_Game := Gtk_Menu_Item_New_With_Label("Advanced");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_Advanced_Game,
         "activate",
         Advanced_Game_Callback'access,
         Main_Window);
      Menu_Game.Append(Menu_Item_Advanced_Game);

      Menu_Item_Expert_Game := Gtk_Menu_Item_New_With_Label("Expert");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_Expert_Game,
         "activate",
         Expert_Game_Callback'access,
         Main_Window);
      Menu_Game.Append(Menu_Item_Expert_Game);

      Menu_Item_Custom_Game := Gtk_Menu_Item_New_With_Label("Custom");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_Custom_Game,
         "activate",
         Custom_Game_Callback'access,
         Main_Window);
      Menu_Game.Append(Menu_Item_Custom_Game);

      Menu_Game.Append(Gtk_Separator_Menu_Item_New);

      Menu_Item_Style := Gtk_Image_Menu_Item_New_From_Stock(
         "gtk-preferences",
         null);
     Menu_Item_Style.Set_Label("Style");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_Style,
         "activate",
         Style_Callback'access,
         Main_Window);
      Menu_Game.Append(Menu_Item_Style);

      Menu_Game.Append(Gtk_Separator_Menu_Item_New);

      Menu_Item_Quit := Gtk_Image_Menu_Item_New_From_Stock(
         "gtk-quit",
         null);
      Menu_Item_Quit.Set_Label("Quit");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_Quit,
         "activate",
         Quit_Callback'access,
         Main_Window);
      Menu_Game.Append(Menu_Item_Quit);

      Menu_Item_Help := Gtk_Menu_Item_New_With_Label("?");
      Menu_Bar.Append(Menu_Item_Help);

      Menu_Help := Gtk_Menu_New;
      Menu_Item_Help.Set_Submenu(Menu_Help);

      Gtk_New_Vbox(Main_Window.Vbox);
      Main_Window.Vbox.Pack_Start(
         Child=>Menu_Bar,
         Expand=>false,
         Fill=>false);

      Menu_Item_About := Gtk_Image_Menu_Item_New_From_Stock(
         "gtk-about",
         null);
      Menu_Item_About.Set_Label("About");
      P_Menu_Item_UHandlers.Connect(
         Menu_Item_About,
         "activate",
         About_Callback'access,
         Main_Window);
      Menu_Help.Append(Menu_Item_About);


      Gtk_New(Main_Window.Counter,"Cnt");

      Gtk_New(
         Main_Window.Table,
         Guint(Main_Window.Height),
         Guint(Main_Window.Width),
         true);

      --Create and build cells
      Main_Window.Cells := new T_Cell_Tab(
         1..Main_Window.Height,
         1..Main_Window.Width);

      for row in Main_Window.Cells'Range(1) loop
         for col in Main_Window.Cells'Range(2) loop
            Main_Window.Cells(row, col) := New_T_Cell;
            Main_Window.Table.Attach(
               Main_Window.Cells(row,col).Alignment,
               Guint(col-1),
               Guint(col),
               Guint(row-1),
               Guint(row));
            Connect(
               Main_Window.Cells(row,col).Button,
               "button_press_event",
               To_Marshaller(Cell_Clicked_Callback'access),
               T_Cell_Callback_Data'(Main_Window,Row,Col));
         end loop;
      end loop;

      Gtk_New(Scrollwin);

      Main_Window.Place_Mines;

      Frame1.Add(Main_Window.Counter);
      Main_Window.Counter.Set_Padding(Gint(5),Gint(5));
      Main_Window.Vbox.Pack_Start(
         Child => Frame1,
         Expand => false,
         Fill => false,
         Padding=> 0);
      Scrollwin.Add_With_Viewport(Main_Window.Table);
      Main_Window.Vbox.Pack_Start(Scrollwin);
      Main_Window.Win.Add(Main_Window.Vbox);


      Main_Window.Set_Nb_Flag(Main_Window.Nb_Flag);
      P_Window_UHandlers.Connect(
         Main_Window.Win,
         "destroy",
         Stop_Program_Callback'access,
         Main_Window) ;

      Main_Window.Win.Show_All;
   end Init;

   function New_T_Main_Window(
      Height: Natural;
      Width : Natural;
      Nb_Mine: Natural) return T_Main_Window is
      Main_Window: T_Main_Window := new T_Main_Window_Record;
   begin
      Main_Window.Init(Height, Width, Nb_Mine);
      return Main_Window;
   end New_T_Main_Window;

   procedure Destroy (
      Main_Window: not null access T_Main_Window_Record) is
   begin
      if Main_Window.Cells /= null then
         for row in Main_Window.Cells'Range(1) loop
            for col in Main_Window.Cells'Range(2) loop
               if (Main_Window.Cells(row,col) /= null) then
                  Main_Window.Cells(row,col).Destroy;
                  free(Main_Window.Cells(row,col));
               end if;
            end loop;
         end loop;
         free(Main_Window.Cells);
      end if;
   end;

   procedure Finalize(
      Main_Window : in out T_Main_Window_Record) is
   begin
      if Main_Window.Cells /= null then
         for row in Main_Window.Cells'Range(1) loop
            for col in Main_Window.Cells'Range(2) loop
               if (Main_Window.Cells(row,col) /= null) then
                  free(Main_Window.Cells(row,col));
               end if;
            end loop;
         end loop;
         free(Main_Window.Cells);
      end if;
   end Finalize;

   procedure Set_Nb_Flag(
      Main_Window : not null access T_Main_Window_Record;
      Nb_Flag: Natural) is
   begin
      Main_Window.Nb_Flag := Nb_Flag;
      Main_Window.Counter.Set_Markup(
         "<span font-weight=""bold"">" &
         Natural'Image(Nb_Flag) & "</span>");
   end;

   procedure Place_Mine(
      Main_Window: not null access T_Main_Window_Record;
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
      Main_Window: not null access T_Main_Window_Record) is
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
      for M in 1..Main_Window.Nb_Mine loop
         loop
            row := Natural(Random(Gen) * Mult_R + Add_R);
            col := Natural(Random(Gen) * Mult_C + Add_C);
            exit when not Main_Window.Cells(Row, Col).Mined;
         end loop;
         Place_Mine(Main_Window, row, col);
      end loop;
   end Place_Mines;

   procedure New_Grid(
      Main_Window: not null access T_Main_Window_Record;
      Height: Natural;
      Width: Natural) is
   begin
      Put_Line("New Grid");
      Main_Window.Height := Height;
      Main_Window.Width := Width;
      
      Main_Window.Cells := new T_Cell_Tab(
         1..Main_Window.Height,
         1..Main_Window.Width);

      for row in Main_Window.Cells'Range(1) loop
         for col in Main_Window.Cells'Range(2) loop
            Main_Window.Cells(row, col) := New_T_Cell;
            Main_Window.Table.Attach(
               Main_Window.Cells(row,col).Alignment,
               Guint(col-1),
               Guint(col),
               Guint(row-1),
               Guint(row));
            Connect(
               Main_Window.Cells(row,col).Button,
               "button_press_event",
               To_Marshaller(Cell_Clicked_Callback'access),
               T_Cell_Callback_Data'(Main_Window,Row,Col));
         end loop;
      end loop;
      Main_Window.Table.Resize(Guint(Height),Guint(Width));
      Main_Window.Win.Show_All;
   end New_Grid;

   procedure Destroy_Grid (
      Main_Window: not null access T_Main_Window_Record) is
   begin
      if Main_Window.Cells /= null then
         for row in Main_Window.Cells'Range(1) loop
            for col in Main_Window.Cells'Range(2) loop
               if (Main_Window.Cells(row,col) /= null) then
                  Main_Window.Cells(row,col).Destroy;
                  free(Main_Window.Cells(row,col));
               end if;
            end loop;
         end loop;
         free(Main_Window.Cells);
      end if;
   end Destroy_Grid;

   procedure Dig_Around(
      Main_Window: not null access T_Main_Window_Record;
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
            End_Game(Main_Window,false);
            Main_Window.Loose_Reveal;
            return;
         end if;
         Main_window.Nb_Unmined_Cell :=
            Main_window.Nb_Unmined_Cell - 1;
         if Main_window.Nb_Unmined_Cell = 0 then
            Put_Line("Gagné");
            End_Game(Main_Window,true);
            Main_Window.Win_Reveal;
            return;
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
      end if;
   end Dig_Around;

   procedure Loose_Reveal(
      Main_Window: not null access T_Main_Window_Record) is
   begin
      for Cell of Main_Window.Cells.all loop
         Cell.Loose_Reveal;
      end loop;
   end Loose_Reveal;

   procedure Win_Reveal(
      Main_Window: not null access T_Main_Window_Record) is
   begin
      for Cell of Main_Window.Cells.all loop
         Cell.Win_Reveal;
      end loop;
   end Win_Reveal;

   procedure End_Game(
      Main_Window: not null access T_Main_Window_Record;
      Win : boolean) is
      Message_Win : Gtk_Window;
      Box : Gtk_Vbox;
      Lbl : Gtk_Label;
      Btn : Gtk_Button;
   begin
      Gtk_New(Message_Win);
      Message_Win.Set_Transient_For(Main_Window.Win);
      Gtk_New_Vbox(Box);
      Message_win.Add(Box);
      if Win then
         Gtk_New(Lbl, "You win!");
      else
         Gtk_New(Lbl, "You Loose!");
      end if;
      Box.Pack_Start(Lbl);
      Gtk_New(Btn, "Ok");
      P_Message_Ok_URHandlers.Connect(
         Btn,
         "clicked",
         Message_Ok_Callback'access,
         Message_Win);
      Box.Pack_Start(Btn);
      Message_Win.Show_All;
   end End_Game;

   procedure New_Game(
      Main_Window: not null access T_Main_Window_Record;
      Height: Natural;
      Width: Natural;
      Nb_Mine: Natural) is
   begin
      Main_Window.Destroy_Grid;
      Main_Window.Height := Height;
      Main_Window.Width := Width;
      Main_Window.Nb_Mine := Nb_Mine;
      Main_Window.Nb_Flag := Nb_Mine;
      Main_Window.Set_Nb_Flag(Nb_Mine);
      Main_Window.Nb_Unmined_Cell := Height * Width - Nb_Mine;
      Main_Window.New_Grid(Height,Width);
      Main_Window.Place_Mines;
   end New_Game;

   procedure Set_Cell_Style(
      Main_Window: not null access T_Main_Window_Record;
      Style : T_Style) is
   begin
      for Cell of Main_Window.Cells.all loop
         Cell.Style := Style;
         Cell.Redraw;
      end loop;
   end Set_Cell_Style;


   procedure New_Game_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.New_Game(
         Main_Window.Height,
         Main_Window.Width,
         Main_Window.Nb_Mine);
   end New_Game_Callback;

   procedure New_Grid_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.New_Grid(5,5);
   end;

   procedure Destroy_Grid_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.Destroy_Grid;
   end Destroy_Grid_Callback;

   procedure Beginner_Game_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.New_Game(9,9,10);
   end Beginner_Game_Callback;

   procedure Advanced_Game_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.New_Game(16,16,40);
   end Advanced_Game_Callback;

   procedure Expert_Game_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
   begin
      Main_Window.New_Game(16,30,99);
   end Expert_Game_Callback;

   procedure Destroy_Dialog (Win : access Gtk_Dialog_Record'Class;
      Ptr : Gtk_Dialog) is
   begin
      Put_Line("Destroy_Dialog");
      Win.Destroy;
   end;

   procedure Custom_Game_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
      Custom_Game_Dialog : Gtk_Dialog;
      Response : Gtk_Response_Type;
      Table: Gtk_Table;
      Height_Field : Gtk_Spin_Button;
      Width_Field : Gtk_Spin_Button;
      Nb_Mine_Field : Gtk_Spin_Button;
   begin
      Custom_Game_Dialog := Gtk_Dialog_New(
         Title=>"Custom Game",
         Parent=>Main_Window.Win,
         Flags=>Destroy_With_Parent );

      Gtk_New(
         Table,
         Guint(3),
         Guint(2),
         false);

      Gtk_New(
         Height_Field,
         Gdouble(0),
         Gdouble(99),
         Gdouble(1));
      Height_Field.Set_Value(Gdouble(Main_Window.Height));

      Gtk_New(
         Width_Field,
         Gdouble(0),
         Gdouble(99),
         Gdouble(1));
      Width_Field.Set_Value(Gdouble(Main_Window.Width));

      Gtk_New(
         Nb_Mine_Field,
         Gdouble(0),
         Gdouble(99),
         Gdouble(1));
      Nb_Mine_Field.Set_Value(Gdouble(Main_Window.Nb_Mine));


      Custom_Game_Dialog.Get_Content_Area.
         Pack_Start(Table);

         Table.Attach(Gtk_Label_New("Height"),
            Guint(0),
            Guint(1),
            Guint(0),
            Guint(1)
         );
         Table.Attach(
            Height_Field,
            Guint(1),
            Guint(2),
            Guint(0),
            Guint(1));

         Table.Attach(Gtk_Label_New("Width"),
            Guint(0),
            Guint(1),
            Guint(1),
            Guint(2)
         );
         Table.Attach(
            Width_Field,
            Guint(1),
            Guint(2),
            Guint(1),
            Guint(2));

         Table.Attach(Gtk_Label_New("Mines"),
            Guint(0),
            Guint(1),
            Guint(2),
            Guint(3)
         );
         Table.Attach(
            Nb_Mine_Field,
            Guint(1),
            Guint(2),
            Guint(2),
            Guint(3));

      Custom_Game_Dialog.Add_Action_Widget(
         Gtk_Button_New_From_Stock(Stock_Ok),
         Gtk_Response_Ok);

      Custom_Game_Dialog.Add_Action_Widget(
         Gtk_Button_New_From_Stock(Stock_Cancel),
         Gtk_Response_Cancel);

      --Custom_Game_Dialog.Set_Title("Custom Game");
      Custom_Game_Dialog.Show_All;
      Response := Custom_Game_Dialog.Run;

      if Response = Gtk_Response_Ok then
         Main_Window.New_Game(
            Integer(Height_Field.Get_Value),
            Integer(Width_Field.Get_Value),
            Integer(Nb_Mine_Field.Get_Value));
      end if;

      Custom_Game_Dialog.Destroy;
   end Custom_Game_Callback;

   procedure Style_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
      Style_Dialog : Gtk_Dialog;
      Response : Gtk_Response_Type;
      Choice_Box : Gtk_Combo_Box_Text;
   begin
      Style_Dialog := Gtk_Dialog_New(
         Title=>"Custom Game",
         Parent=>Main_Window.Win,
         Flags=>Destroy_With_Parent );

      Gtk_New(Choice_Box);

      for i in T_Style'range loop
         Choice_Box.Append_Text(T_Style'Image(i));
      end loop;

      Style_Dialog.Get_Content_Area.
         Pack_Start(Choice_Box);

      Style_Dialog.Add_Action_Widget(
         Gtk_Button_New_From_Stock(Stock_Ok),
         Gtk_Response_Ok);

      Style_Dialog.Add_Action_Widget(
         Gtk_Button_New_From_Stock(Stock_Cancel),
         Gtk_Response_Cancel);

      --Style_Dialog.Set_Title("Custom Game");
      Style_Dialog.Show_All;
      Response := Style_Dialog.Run;

      if Response = Gtk_Response_Ok then
         if Choice_Box.Get_Active_Text /= "" then
            Main_Window.Set_Cell_Style(
               T_Style'Value(Choice_Box.Get_Active_Text));
         end if;
      end if;

      Style_Dialog.Destroy;
   end Style_Callback;

   procedure Quit_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
      pragma Unreferenced(Emitter);
   begin
      Main_Quit;
   end Quit_Callback;


   procedure About_Callback(
      Emitter : access Gtk_Menu_Item_Record'class;
      Main_Window : T_Main_Window) is
      About_Dialog: Gtk_About_Dialog;
      Response : GTK_Response_Type;
      Logo : Gdk_Pixbuf;
      Error: GError;
      type T_Authors is array(1..1) of access String;
      Authors : GNAT.Strings.String_List(1..1);
   begin
      About_Dialog := Gtk_About_Dialog_New;
      About_Dialog.Set_Transient_For(Main_Window.Win);
      Gdk_New_From_File(Logo, "share/logos/mine-logo.png", Error);
      About_Dialog.Set_Logo(Logo);

      Authors(1):= new String'("Yruama_Lairba")  ;
      About_Dialog.Set_Authors(Authors);
      About_Dialog.Set_Copyright("You can use, share and modify this program according to the GPL Version 3 License.");
      About_Dialog.Set_License("This doesn't seems to work");
      About_Dialog.Set_License_Type(License_Gpl_3_0);
      About_Dialog.Set_Comments(
         "Minesweeper is build by following practictal exercises proposed by Openclassroom ada courses (see https://openclassrooms.com/fr/courses/900279-apprenez-a-programmer-avec-ada)");
      About_Dialog.Show_All;
      Response := About_Dialog.Run;
      About_Dialog.Destroy;
   end About_Callback;

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
                  if Data.Main_Window.Nb_Flag > 0 then
                     Cell.Flag;
                     Data.Main_Window.Set_Nb_Flag(
                        Data.Main_Window.Nb_Flag - 1);
                  end if;
               when Flagged =>
                  Cell.Unflag;
                  Data.Main_Window.Set_Nb_Flag(
                     Data.Main_Window.Nb_Flag + 1);
               when others => null;
            end case;
         when others => null;
      end case;
      --left click animation only when state is normal
      return No_Animation ;
   end Cell_Clicked_Callback;

end P_Main_Window;

