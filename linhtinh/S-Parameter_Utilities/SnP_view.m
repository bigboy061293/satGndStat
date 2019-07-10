%% SnP S-parameter viewer
% A simple shell to feed a file name and path to Spar_Plot.m
% Dick Benson, October 2015, September 2018
clear
clc
close

p = mfilename('fullpath');  % returns where this mcode lives.
% But it also returns the function name which needs to be stripped off.
k=strfind(p,'\');
home_path=p(1:k(end));
f_name='Last_SnP_Viewer_Path.mat';  % see if this exists
if exist(f_name,'file')
    last_path   = load(f_name);
    if ~exist(last_path.Path,'dir')
        last_path.Path='';
    end;
else
    last_path.Path='';
end;

filter_spec = [last_path.Path,'*.s*p'];
[Name,Path,filter]=uigetfile(filter_spec,'Read SnP file.');

if Name ~=0
    Spar_Plot(Path,Name)
    save([home_path,f_name],'Path'); % update any change to the Path
end;


