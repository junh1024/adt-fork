function [ h ] = ntitle(titlestring,varargin)
% ntitle(titlestring,varargin) places a title within the plot instead of on
% top. In the spirit of Edward Tufte, this is intended to keep the title
% close to the data it describes and minimize wasted space.  The ntitle function 
% may prove particularly  useful for figures with several subplots, where titles 
% can sometimes become confused with xlabels above them. 
% 
% By default, ntitle centers the title at the top of the plot, but any of
% the location coordinates (e.g., north, southwest, etc.) can be used with
% the argument 'location'.  Output h provides the handle for the ntitle. 
% 
% Created by Chad A. Greene on the fifth of June, 2013. 
%
% % Example: 
% 
% % First make a plot: 
% x = -50:.1:50; 
% y = 10*sin(x)+.1*x.^2; 
% plot(x,y);
% axis([-50 50 -50 300])
% box off
% 
% % Then here are 9 obnoxious examples of how to use ntitle: 
% ntitle('Title 1');
% ntitle('{\it Title 2}','location','northwest');
% ntitle('Title 3 ','location','northeast','fontsize',10,'edgecolor','b');
% ntitle(' Title 4 ','location','east','color','r');
% ntitle('Title 5','location','center','color','m','backgroundcolor','y');
% ntitle(' Title 6','location','west','color',[.2 .5 .8]);
% ntitle(' Title 7','location','southwest','fontname','Courier');
% ntitle('Title 8','location','south','fontweight','bold','fontname','Times');
% h9 = ntitle('Title 9 ','location','southeast','fontsize',30);


h= text(.5,1,titlestring,...
    'units','normalized',...
    'horizontalalignment','center',...
    'verticalalignment','top');


for n=1:2:length(varargin)
    if strcmpi(varargin{n},'location')
        if strcmpi(varargin{n+1},'northwest')
            set(h,'horizontalalignment','left','verticalalignment','top','position',[0 1 0])
        
        elseif strcmpi(varargin{n+1},'north')
            % This case is default and has already been set.
        
        elseif strcmpi(varargin{n+1},'northeast')
            set(h,'horizontalalignment','right','verticalalignment','top','position',[1 1 0])
                    
        elseif strcmpi(varargin{n+1},'west')
            set(h,'horizontalalignment','left','verticalalignment','middle','position',[0 .5 0])
            
        elseif strcmpi(varargin{n+1},'center')
            set(h,'horizontalalignment','center','verticalalignment','middle','position',[.5 .5 0])
            
        elseif strcmpi(varargin{n+1},'east')
            set(h,'horizontalalignment','right','verticalalignment','middle','position',[1 .5 0])
            
        elseif strcmpi(varargin{n+1},'southwest')
            set(h,'horizontalalignment','left','verticalalignment','bottom','position',[0 0 0])
            
        elseif strcmpi(varargin{n+1},'south')
            set(h,'horizontalalignment','center','verticalalignment','bottom','position',[.5 0 0])
            
        elseif strcmpi(varargin{n+1},'southeast')
            set(h,'horizontalalignment','right','verticalalignment','bottom','position',[1 0 0])
            
        end
    
    else
        set(h,varargin{n},varargin{n+1})
    end
end

% Return the title handle only if it is desired: 
if nargout==0
    clear h; 
end


end

%% downloaded from MATLAB File Exchange
% http://www.mathworks.com/matlabcentral/fileexchange/42114-ntitle

%% license.txt
% Copyright (c) 2013, Chad Greene
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
