% main : Word Spotting using DTW

nom_ruta_dir = 'words_GW';
znfil = 5; zncol = 10;  % ZONING

fitxers = dir(nom_ruta_dir);
num_imatges = 0;
for(i=1:length(fitxers))
    llargaria = length(fitxers(i).name);
    if((llargaria>4)&(fitxers(i).name(llargaria-3:llargaria)=='.tif'))        
        num_imatges = num_imatges +1;
        
        %nom_im = [nom_ruta_dir '/' fitxers(i).name];   %% LINUX!!!!
        nom_im = [nom_ruta_dir '\' fitxers(i).name];   %% WINDOWS!!!!
        sortida = [' - Imatge ' num2str(num_imatges) ' : ' nom_im]; disp(sortida);
        
        Rath_feat{num_imatges}.m = f_calcula_DTW_Rath(nom_im);
        Zoning_feat{num_imatges}.m = f_zoning_sum( nom_im, znfil, zncol );
        Imatges{num_imatges}.im = imread(nom_im);

    end
    
end

disp('COMPARISONS');
% matriz distancias
for(i=1:num_imatges)
    disp(i);
    % the matrix is symmetric
    for(j=i:num_imatges)
        [distancia, m_cami_seguit] = f_compara_matrius_DTW(Rath_feat{i}.m,Rath_feat{j}.m);
        distancias_Rath(i,j) = distancia;
        distancias_Rath(j,i) = distancia;
        clear distancia, clear m_cami_seguit,
        distancias_Zoning(i,j) = sqrt(f_dist_euclidea2(Zoning_feat{i}.m,Zoning_feat{j}.m));
        distancias_Zoning(j,i) = sqrt(f_dist_euclidea2(Zoning_feat{i}.m,Zoning_feat{j}.m));
    end
end


distancias_Rath,
distancias_Zoning,


% DISPLAY
num_results=4;

f_display_results(Imatges,num_imatges,num_results,distancias_Rath);  
f_display_results(Imatges,num_imatges,num_results,distancias_Zoning); 



