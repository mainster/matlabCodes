function togglebutton1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed, take appropriate action
   ...
elseif button_state == get(hObject,'Min')
	% Toggle button is not pressed, take appropriate action
    ...
end