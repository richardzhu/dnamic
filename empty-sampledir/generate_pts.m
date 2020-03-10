clc; clear all;
% this will simulate a UMI set from the image im.tif, and write these to a
% position file for use with simOps.py

% read in simulation settings file
settingsfile = textread('sim_params.csv','%s','delimiter',' ');
Nbcn = 5000;
Ntrg = 5000;
spat_dims = 2;

for i = 1:2:length(settingsfile)
    setting_key = settingsfile{i};
    setting_val = settingsfile{i+1};
    if strcmp(setting_key,'-posfilename')
        posfilename = setting_val;
    elseif strcmp(setting_key,'-lin_cycles')
        lincycles = str2num(setting_val);
    elseif strcmp(setting_key,'-exp_cycles')
        expcycles = str2num(setting_val);
    elseif strcmp(setting_key,'-diffconst')
        diffconst = str2num(setting_val);
    end;
end;
sim_positions = zeros(Nbcn+Ntrg,2+spat_dims);
sim_positions((Nbcn+1):(Nbcn+Ntrg),2) = 1; % indicate which are targets
im = imread('im.tif');
im = (im > 0);
[rows,cols] = size(im);
xcoords = zeros(rows,cols);
ycoords = zeros(rows,cols);
for r = 1:rows
    for c = 1:cols
        if im(r,c) > 0
            xcoords(r,c) = c;
            ycoords(r,c) = -r;
        end;
    end;
end;

good_indices = find(xcoords(:) > 0);
xcoords = xcoords(good_indices);
ycoords = ycoords(good_indices);
Npx = length(good_indices);

for n = 1:(Nbcn+Ntrg)
    sim_positions(n,1) = n-1; % index from 0
    myrandindex = ceil(rand(1)*Npx);
    sim_positions(n,3) = xcoords(myrandindex) + (rand(1)-0.5);
    sim_positions(n,4) = ycoords(myrandindex) + (rand(1)-0.5);
end;

sim_positions(:,3) = sim_positions(:,3)-mean(sim_positions(:,3));
sim_positions(:,4) = sim_positions(:,4)-mean(sim_positions(:,4));

diff_lengthscale = sqrt(8*3*diffconst*(lincycles + expcycles));
image_width = max(sim_positions(:,3))-min(sim_positions(:,3));
sim_positions(:,[3 4]) = sim_positions(:,[3 4])*(4*diff_lengthscale/image_width); % arbitrary: set to simulate reasonable point spacings for simulation
csvwrite(posfilename,sim_positions);
myvars = var(sim_positions);
disp(sqrt(myvars(3:4)))

mycolors = colormap('hsv');
colorcoords = zeros(Nbcn+Ntrg,3);
min_x = min(sim_positions(:,3));
max_x = max(sim_positions(:,3));
min_y = min(sim_positions(:,4));
max_y = max(sim_positions(:,4));
[totcolors,dummyvar] = size(mycolors);
min_x = min_x - .5;
max_x = max_x + .5;
min_y = min_y - .5;
max_y = max_y + .5;
for n = 1:(Nbcn+Ntrg)
    colorcoords(n,:) = mycolors(ceil(((sim_positions(n,3)-min_x)/(max_x+.1-min_x))*totcolors),:);
end;
sz = 10;
colordef white
scatter(sim_positions(:,3)'/diff_lengthscale,sim_positions(:,4)'/diff_lengthscale,sz*ones(1,Nbcn+Ntrg),colorcoords,'.');
set(gcf,'color','w');
set(gca,'XLim',[floor(min_x/diff_lengthscale)-1 ceil(max_x/diff_lengthscale)+1]);
set(gca,'YLim',[floor(min_y/diff_lengthscale) ceil(max_y/diff_lengthscale)]);
set(gca,'FontSize',15);
set(gca,'LineWidth',2);
daspect([1 1 1])