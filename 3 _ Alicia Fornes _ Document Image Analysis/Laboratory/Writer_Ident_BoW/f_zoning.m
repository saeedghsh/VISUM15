function [ m_zoning ] = f_zoning( im_orig, znfil, zncol )
% Zoning descriptor: Num of pixels per region
% Binary image, foreground pixels = 1

im_in = f_enquadra_im(im_orig);  % remove borders

%%%%

m_zoning= zeros(znfil, zncol);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[resize_fil,resize_col] = size(im_in);

mod_col = mod(resize_col,zncol);
mod_fil = mod(resize_fil,znfil);

if(mod_col > 0)
    resize_col = resize_col + zncol - mod_col;
end

if(mod_fil > 0)
    resize_fil = resize_fil + znfil - mod_fil;
end

im = imresize(im_in,[resize_fil,resize_col]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[im_fil,im_col] = size(im);

% Divide into zn_rows x zn_cols
bot_fil = round(im_fil / znfil);
bot_col = round(im_col / zncol);


% vector sections rows
pos = 1;
seccio_fil(1) = 1;
for(i=bot_fil:bot_fil:im_fil)
    pos = pos +1;
    seccio_fil(pos) = i;
    if(i < im_fil)
        pos = pos +1;
        seccio_fil(pos) = i+1;
    end
end


% vector sections cols
pos = 1;
seccio_col(1) = 1;
for(i=bot_col:bot_col:im_col)
    pos = pos +1;
    seccio_col(pos) = i;
    if(i < im_col)
        pos = pos +1;
        seccio_col(pos) = i+1;
        
    end

end

area_fila = 0; 

for(f=1:2:(length(seccio_fil)-1))
    area_fila = area_fila +1;
    area_columna = 0;
    for(c=1:2:(length(seccio_col)-1))
        area_columna = area_columna +1;        
        tros = im(seccio_fil(f):seccio_fil(f+1),seccio_col(c):seccio_col(c+1));
        m_zoning(area_fila, area_columna) = sum(sum(tros));
    end
end

		
%figure, imshow(m_zoning,[]);

% reshape bi-dimensional image into one vector
m_zoning = reshape(m_zoning,[1,znfil*zncol]);




