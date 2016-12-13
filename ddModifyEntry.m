function ddModifyEntry(DataDict, Entry, Value)
% ddModifyEntry(DataDict, Entry, Value) Modify value of data dictionary entry
%
%   DATADICT = Data dictionary name or Simulink.data.Dictionary object
%   ENTRY = Name of entry 
%   VALUE = New value for ENTRY
%
%   12.12.2016  MDB

if isa(DataDict, 'Simulink.data.Dictionary')
    ddo=DataDict;
else
    ddo=Simulink.data.dictionary.open(DataDict);
end

dds=ddo.getSection('Design Data');
entry=dds.getEntry(Entry);
entryValue=entry.getValue;

if isa(entryValue, 'Simulink.Parameter')
    entryValue.Value=Value;
elseif isnumeric(entryValue)
    entryValue=Value;
end

entry.setValue(entryValue);
ddo.saveChanges;