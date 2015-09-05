%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

zipfile = ['backup',datestr(now,'yyyymmddTHHMMSS')]
zip(zipfile,{'*.m','*.mat'})
[status,message]=movefile([zipfile,'*'],'..\..\backup\')