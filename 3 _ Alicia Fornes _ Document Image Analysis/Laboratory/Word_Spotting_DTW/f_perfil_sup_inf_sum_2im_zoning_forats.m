function [ minims_x,minims_y_norm,maxims_x,maxims_y_norm, m_sum_norm, nforats_norm, im, centr_col] = f_perfil_sup_inf_sum_2im_zoning_forats (im_rellenada, im_orig2)

% For each column, compute the profiles (sup, inf),
% the number of foreground pixels and number of holes
% All values are normalized (0-100)
 
draw_figure=0; % if 1 then draw figure

im=f_enquadra_im(im_orig2);  % Remove borders

% Search the Num of zones and resize if necessary
zoning_num_files = 1;
zoning_num_columnes = 4;

[resize_fil,resize_col] = size(im);

mod_col = mod(resize_col,zoning_num_columnes);
mod_fil = mod(resize_fil,zoning_num_files);

if(mod_col > 0)
    resize_col = resize_col + zoning_num_columnes - mod_col;
end

if(mod_fil > 0)
    resize_fil = resize_fil + zoning_num_files - mod_fil;
end


im = imresize(im,[resize_fil,resize_col]);

% Search the centroid
STATS = regionprops(double(im>0),'centroid');
centr_col = floor(STATS.Centroid(1)); 

[nfil,ncol]=size(im);

minims_x = 1:ncol;
maxims_x = 1:ncol;

% Compute the profiles
for(i=1:ncol)
    [minim,maxim] = f_busca_minmax(im(:,i),nfil);    
    minims_y(i)=minim;
    maxims_y(i)=maxim;   
end


% Num of holes
for(i=1:ncol)
    nforats(i) = f_busca_num_forats(im(:,i));     
end


%%%%%%%%%%%%%%%%%%%%%%
sumavert = sum(im~=0);

[nfil,ncol]=size(im);

% Normalize 0-100
m_sum_norm = round((100 * sumavert(:)) /nfil);
 
minims_y_norm = round((100 * minims_y(:)) /nfil);
maxims_y_norm = round((100 * maxims_y(:)) /nfil);

maxim_forats = max(nforats);
if(maxim_forats==0)
    maxim_forats = 1;
end
nforats_norm = round((100*nforats(:)) / maxim_forats(1));


if (draw_figure==1)
    z=figure;subplot(1,4,1); imshow(im);
    hold on;
    plot([minims_y,minims_x],'ro');
    plot([maxims_y,maxims_x],'b*');

    figure(z);subplot(1,4,2); hold on;
    plot([minims_y],'r'); axis ij,
    subplot(1,4,3);
    plot([maxims_y],'b'); axis ij,
    
    figure(z);subplot(1,4,4); hold on;    
    plot([sumavert_norm],'b');    
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [minim,maxim] = f_busca_minmax(columna,llarg_columna)
   
    % Search the max
    j=1;
    while((j<=llarg_columna)&&(columna(j)==0))
        j = j+1;
    end
    if(j>llarg_columna)
        maxim = llarg_columna;
    else
        maxim = j;
    end

    % Search the min
    j=llarg_columna;
    while ((j>=1)&&(columna(j)==0))
        j = j-1;
    end
    if(j<1)
        minim = llarg_columna;
    else
        minim = j;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nforats] = f_busca_num_forats(columna)    
    % Search num of transitions 0->1

    llarg_columna = length(columna);
    nforats = 0;
    for(i=1:(llarg_columna-1))
        if(columna(i)==0) && (columna(i+1)==1)
            nforats = nforats+1;
        end
    end
    
      