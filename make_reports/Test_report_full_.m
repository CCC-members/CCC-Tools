%% Example report for codes (See the function f_report for check all the options)
clc;
clear all;
close all;

addpath('functions');
addpath('templates');
addpath('make_reports');
addpath('test_data');
disp("-->> Starting process");

output_path = fullfile(pwd,'Reports');
load('mycolormap_brain_basic_conn.mat');
disp("--------->> Processing CHBM dataset <<---------");
disp("-------------------------------------------------");
disp("-->> Finding completed files");
root_path = "test_data";

disp("-------------------------------------------------");

% Creating a report
report_name = 'report_name';
f_report('New');
% Add a title to the report
f_report('Title','Sensor and activation results');
% Add a title to the report
f_report('Header','Example report','CHBM dataset cleanning data');


% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Import channel info.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Selecting opened and closed eyes events';
line_5 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_6 = 'Interpolate all the removed channels.';
% Multiline information cell array
f_report('Info',{line_1,line_2,line_3,line_4,line_5,line_6}); 

subjects = dir(fullfile(root_path));
subjects(ismember({subjects.name},{'..','.'})) = [];
for i=1:length(subjects)
    subject                 = subjects(i);
    
    %Getting subject surface
    Sc        = load(fullfile('templates/FSAve_cortex_8k.mat'));
    Vertices    = Sc.Vertices;
    VertConn    = Sc.VertConn;
    SulciMap    = Sc.SulciMap;
    smoothValue = 0.66;
    SurfSmoothI = 10;
    Vertices    = tess_smooth(Vertices, smoothValue, SurfSmoothI,VertConn, 1);
    Faces       = Sc.Faces;   
    
    % Getting figures
    fig_1_delta = openfig(fullfile(subject.folder,subject.name,'Power Spectral Density - delta_0Hz-4Hz.fig'));
    title('Power Spectral');
    fig_2_delta = openfig(fullfile(subject.folder,subject.name,'Scalp_2D_delta_2.5Hz.fig'));
    title('Topology');
    fig_3_delta = openfig(fullfile(subject.folder,subject.name,'BC_VARETA_activation_delta_2.5Hz.fig'));
    title('Activation rigth view');
    fig_4_delta = openfig(fullfile(subject.folder,subject.name,'BC_VARETA_activation_delta_2.5Hz.fig'));
    title('Activation left view');
    fig_1_alpha = openfig(fullfile(subject.folder,subject.name,'Power Spectral Density - alpha_7Hz-14Hz.fig'));
    title('Power Spectral');
    fig_2_alpha = openfig(fullfile(subject.folder,subject.name,'Scalp_2D_alpha_10Hz.fig'));
    title('Topology');
    fig_3_alpha = openfig(fullfile(subject.folder,subject.name,'BC_VARETA_activation_alpha_10Hz.fig'));
    title('Activation rigth view');
    fig_4_alpha = openfig(fullfile(subject.folder,subject.name,'BC_VARETA_activation_alpha_10Hz.fig'));
    title('Activation left view'); 
    
    % Marging fifures as sobplots in the same figure    
    figures = {fig_1_delta,fig_2_delta,fig_3_delta,fig_4_delta,fig_1_alpha,fig_2_alpha,fig_3_alpha,fig_4_alpha}; % cell array of figures
    fig_name        = strcat("Subject-",subject.name); % Figure name
    fig_title       = 'BC-VARETA Spectral and Activation for delta & alpha band'; % Figure tittle
    % See function documentation
    fig_out         = merge_figures(fig_name, fig_title, figures,'cmap',cmap,'width',875,'height',350,...
        'rows', 2, 'cols', 4,'axis_on',{'on','off','off','off','on','off','off','off'},...
        'view_orient',{[],[],[0,0],[180,0],[],[],[0,0],[180,0]});
    
    % Add a figure to the report
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,350]);
    close(fig_1_delta,fig_2_delta,fig_3_delta,fig_4_delta,fig_1_alpha,fig_2_alpha,fig_3_alpha,fig_4_alpha,fig_out);
    
end

% Add the footer info to the report
footer_title = 'Organization';
text = 'All rights reserved';
copyright = '@copy CC-Lab';
contact = 'cc-lab@neuroinformatics-collaboratory.org';
references = {'https://github.com/CCC-members', 'https://www.neuroinformatics-collaboratory.org/'};

f_report('Footer', footer_title, text, 'ref', references, 'copyright', copyright, 'contactus', contact);
disp('-->> Saving report.');
% Export the report
disp('-->> Exporting report.');
% report_name = 'CHBM_by_events';
FileFormat = 'html';
f_report('Export',output_path, report_name, FileFormat);

disp("-->> Process finished");