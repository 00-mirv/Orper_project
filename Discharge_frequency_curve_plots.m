% Discharge_frequemcy_curves

%   Description of the goal and usage of the script

%%%% From historical hydrological (discharge) data colleted from 35 rivers,
%%%% this script extracts hydrological data and creates a figure with three
%%%% subplots: histogram of discharge occurances, historical discharge vs 
%%%% time and discharge frequency curve. Q10 and Q90 are then calculated.


%%author__ = 
%%contact__ = xxx@epfl.ch
%%date__ = 2022/01/01
%%status__ = Production


%%%%%%%%%%%%%%%%%%%%
% Review History   %
%%%%%%%%%%%%%%%%%%%%

%%% Reviewed by: not reviewed yet


%%%%%%%%%%%%%%%%%%%%
% Requirements     %
%%%%%%%%%%%%%%%%%%%%

%%% Other m-files required
% none

%%% Toolboxes 
% none

%%% Data files requried
% Excel files with hydrological and morphological discharge data for 35
% rivers

%                            08 - feshie.xlsx            17 - sanjuan1.xlsx          26 - southforksalmon2.xlsx  35 - yellow4.xlsx           
%                            09 - johnsoncreek.xlsx      18 - sanjuan2.xlsx          27 - tay.xlsx                                    
%01 - clearwater1.xlsx       10 - kander.xlsx            19 - sanjuan3.xlsx          28 - virgin.xlsx                             
%02 - clearwater2.xlsx       11 - littlesnake1.xlsx      20 - sanjuan4.xlsx          29 - wind1.xlsx                              
%03 - clearwater3.xlsx       12 - littlesnake2.xlsx      21 - selway.xlsx            30 - wind2.xlsx             
%04 - colorado1.xlsx         13 - nfclearwater.xlsx      22 - selway2.xlsx           31 - yampa.xlsx             
%05 - colorado2.xlsx         14 - riogrande1.xlsx        23 - snake1.xlsx            32 - yellow1.xlsx           
%06 - colorado3.xlsx         15 - riogrande2.xlsx        24 - snake2.xlsx            33 - yellow2.xlsx           
%07 - endrick.xlsx           16 - salmon.xlsx            25 - southforksalmon.xlsx   34 - yellow3.xlsx       

% .mat file with complied river data. variables have been calculated
% complied_river_data.mat



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Start of Code %%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize m-file
clear all; close all; clc

%set working directory
dir('G:\My Drive\4_Activities\4_Summer_school\2023_OpenScience\ORPER_project')

%find river data excel files in working directory
River_data_files=dir('*.xlsx');

%load matrix of data stored for rivers (calcualted using same excel files from a different .m file)
load("compiled_river_data.mat")

% For each river, extract hydrologial data and create figure with three subplots: 
% histogram of discharge occurances, historical discharge vs time and the discharge frequency curve
for river = 1%:length(River_data_files)

    %extract previously calculated discharge curve and discharge histogram
    %discharge histogram
    Discharge_Bins=cell2mat(Binsc(river));
    Discharge_BinValues=cell2mat(BinValuesc(river));

    %discharge curve
    days_per_year=cell2mat(yc(river));
    discharge_curve=cell2mat(Vectorc(river));

    %extract daily average discharge data for each river
    river_file_name=River_data_files(river).name;
    [status,sheets] = xlsfinfo(river_file_name);
    river_name = sheets(1);

    [daily_avg_discharge, t_d_string] = xlsread(river_file_name,1);

    t_d_datetime = datetime(t_d_string,'InputFormat','dd.MM.yyyy');
    start_day = t_d_datetime(1);
    end_day = t_d_datetime(end);

    %% start creating figure with three subplots
    fname = river_name;
    figure('color',[0.3,0.6,0.9])
    title(fname)
    
    %% First subplot: daily average discharge histogram
    subplot(2,2,1)
    drawnow;
    bar(Discharge_BinValues, Discharge_Bins,'histc')
    xmin = Discharge_BinValues(1);
    xmax= Discharge_BinValues(end);
    xlim([xmin xmax])
    title('Discharge histogram')
    ylabel('days')
    xlabel ('discharge [m3/s]')
    
    %% Second subplot: daily average discharge over time
    subplot(2,2,2)
    drawnow;
    plot(t_d_datetime,daily_avg_discharge)
    
    %format plot
    xlim([start_day end_day])
    ax = gca;
    ax.YAxisLocation = 'right';
    title('Discharge time series')
    xlabel('date')
    ylabel('Q (m^3.s^-1)')


    %% Create final subplot with discharge frequency distribution
    subplot(2,2,[3,4])
    drawnow;
    plot(discharge_curve,days_per_year)
    ylim([0 365])
    title('Discharge frequency')
    legend(gca, 'boxoff')
    ylabel('days')
    xlabel('Q (m^3.s^{-1})')
    ylabel ('date')
    set(gca,'FontName','Times New Roman','FontSize',12);
    drawnow

end



