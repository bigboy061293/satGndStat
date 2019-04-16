s = serial('COM16');
set(s,'BaudRate',115200);
fopen(s);
pause on;
while(1)
   fgets(s);
   pause(1);
end