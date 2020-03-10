clc; clear all;

base_order = 'ACGT';
whitebg([0 0 0])
set(gca,'color',[0 0 0])
set(gcf,'color','white');
set(gca,'FontSize',15);

for panel = [0 1]
    % load simulated coordinates
    sim_positions = load('posfile.csv');
    Nbcn = sum(sim_positions(:,2)==0);
    mycolors = colormap('hsv');

    min_x = min(sim_positions(:,3));
    max_x = max(sim_positions(:,3));
    min_y = min(sim_positions(:,4));
    max_y = max(sim_positions(:,4));
    [totcolors,dummyvar] = size(mycolors);
    min_x = min_x - .5;
    max_x = max_x + .5;
    min_y = min_y - .5;
    max_y = max_y + .5;
    if panel == 1
        fileID = fopen('r500000/infer_smle/final_feat_Xumi_smle_data_minuei2dim2DMv1.0_.csv');
        X = load('r500000/infer_smle/final_Xumi_smle_data_minuei2dim2DMv1.0_.csv');
    end;
    if panel == 0
        sim_bcn_indices = find(sim_positions(:,2)==0);
        sim_trg_indices = find(sim_positions(:,2)==1);
        rescale = sqrt(8*3*1.0*26);
        hold('on'); subplot(1,2,panel+1), scatter(sim_positions(sim_bcn_indices,3)'/rescale,sim_positions(sim_bcn_indices,4)'/rescale,25*ones(1,length(sim_bcn_indices)),'w.');
        colorcoords = mycolors(ceil(((sim_positions(sim_trg_indices,3)-min_x)/(max_x+.1-min_x))*totcolors),:);
        hold('on'); subplot(1,2,panel+1), scatter(sim_positions(sim_trg_indices,3)'/rescale,sim_positions(sim_trg_indices,4)'/rescale,25*ones(1,length(sim_trg_indices)),colorcoords,'.');
        orig_stddev = sqrt(sum(var(sim_positions(sim_trg_indices,3:4)'/rescale)));
    else
        C = textscan(fileID,'%f %f %f %f %s','Delimiter',',');
        fclose(fileID);
        sim_index_key =  load('sim_index_key.csv');
        [rows,cols] = size(X);
        mycoordvec = zeros(rows,1);
        colorcoords = zeros(rows,3);
        coordvec = zeros(1,rows);
        outerprodsum = zeros(2,2);
        for row = 1:rows
            if C{2}(row) >= 0 % is target
                encoded_amplicon = C{5}{row}(find(C{5}{row}~='N'));
                myres = 0;
                for i = 0:(length(encoded_amplicon)-1)
                    myres = myres + (find(encoded_amplicon(length(encoded_amplicon)-i)==base_order)-1)*(4^i);
                end;
                myres = sim_index_key(Nbcn + myres + 1);
                coordvec(row) = myres;
                colorcoords(row,:) = mycolors(ceil(((sim_positions(myres + 1,3)-min_x)/(max_x+.1-min_x))*totcolors),:);
                outerprodsum = outerprodsum + (sim_positions(myres + 1,3:4)')*X(row,2:3);
            end;
        end;
        res_trg_indices = find(C{2}>=0);
        res_bcn_indices = find(C{2}<0);
        [u,s,v] = svd(outerprodsum);
        X(:,2:3) = X(:,2:3) * (v * u');
        this_stddev = sqrt(sum(var(X(res_trg_indices,2:3)')));
        X = X*orig_stddev/this_stddev;
        hold('on'); subplot(1,2,panel+1), scatter(X(res_bcn_indices,2)',X(res_bcn_indices,3)',25*ones(1,length(res_bcn_indices)),'w.');
        hold('on'); subplot(1,2,panel+1), scatter(X(res_trg_indices,2)',X(res_trg_indices,3)',25*ones(1,length(res_trg_indices)),colorcoords(res_trg_indices,:),'.');
    end;
    set(gca,'XLim',[-3 3]); set(gca,'YLim',[-4 4]); set(gca,'FontSize',15);
    set(gca,'XTick',-3:3); set(gca,'YTick',-4:4);
    daspect([1 1 1])
    grid on
    ax = gca
    ax.LineWidth = 5
end;

%export_fig(['sim.png'],'-r300');