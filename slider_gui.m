function slider_gui
fh = figure('Position',[250 250 350 350]);
sh = uicontrol(fh,'Style','slider',...
               'Max',100,'Min',0,'Value',25,...
               'SliderStep',[0.05 0.2],...
               'Position',[300 25 20 300],...
               'Callback',@slider_callback);
eth = uicontrol(fh,'Style','edit',...
               'String',num2str(get(sh,'Value')),...
               'Position',[30 175 240 20],...
               'Callback',@edittext_callback);
sth = uicontrol(fh,'Style','text',...
               'String','Enter a value or click the slider.',...
               'Position',[30 215 240 20]);
number_errors = 0;
previous_val = 0;
val = 0;
% ----------------------------------------------------
% Set the value of the edit text component String property
% to the value of the slider.
   function slider_callback(hObject,eventdata)
      previous_val = val;
      val = get(hObject,'Value');
      set(eth,'String',num2str(val));
      sprintf('You moved the slider %d units.',abs(val - previous_val))
   end
% ----------------------------------------------------
% Set the slider value to the number the user types in 
% the edit text or display an error message.
   function edittext_callback(hObject,eventdata)
      previous_val = val;
      val = str2double(get(hObject,'String'));
      % Determine whether val is a number between the 
      % slider's Min and Max. If it is, set the slider Value.
      if isnumeric(val) && length(val) == 1 && ...
         val >= get(sh,'Min') && ...
         val <= get(sh,'Max')
         set(sh,'Value',val);
         sprintf('You moved the slider %d units.',abs(val - previous_val))
      else
      % Increment the error count, and display it.
         number_errors = number_errors+1;
         set(hObject,'String',...
             ['You have entered an invalid entry ',...
             num2str(number_errors),' times.']);
         val = previous_val;
      end
   end
end