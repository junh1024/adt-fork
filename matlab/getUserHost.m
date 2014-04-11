function [ user, host, host_type ] = getUserHost()
    %GetUserHost return user and host
    
    %{
This file is part of the Ambisonic Decoder Toolbox (ADT).
Copyright (C) 2013  Aaron J. Heller

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.
    
You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %}
    
    % Author: Aaron J. Heller <heller@ai.sri.com>
    % $Id$
    
    %%
    if inOctave
        user = getenv('USER');
        host = '';
    else
        user = char(java.lang.System.getProperty('user.name'));
        host = char(java.net.InetAddress.getLocalHost.getHostName);
    end
    
    host_type = computer();
end

