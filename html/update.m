function update
% UPDATE generates html help files for all classes

d = pwd;
D = dir('../+dml/*.m');

s = which('help2html');

f = strfind(s,'/');
if isempty(f)
  cd(d);
  error('path not found');
end

ds = s(1:(f(end)-1));
cd(ds);

for i=1:length(D)
  nme = D(i).name(1:(end-2));
  s = help2html(['dml.' nme]);  
  fid = fopen(fullfile(d,[nme '.html']),'w');
  fprintf(fid,'%s',s);
  fclose(fid);
end

cd(d);
