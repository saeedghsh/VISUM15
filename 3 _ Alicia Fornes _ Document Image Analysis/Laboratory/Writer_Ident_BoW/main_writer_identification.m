% MAIN  : WRITER IDENTIFICATION WITH BAG OF WORDS

% PARAMETERS
nCodeWords = 60;  % Bag of Words - size of the codebook

%%%%%%%%%%%% TRAIN PAGES
nom_ruta_dir_gran = 'TrainPages';

disp('*** TRAINING: COMPUTING THE DESCRIPTORS  ***'); 
directoris = dir(nom_ruta_dir_gran);
posicio = 0;        
num_images = 0;
for(ndir=3:length(directoris))
  if(directoris(ndir).isdir == 1)
    % calculo les imatges d'aquest directori
    posicio = posicio +1;
    nom_directori = directoris(ndir).name; 
    nom_ruta_dir = [nom_ruta_dir_gran '/' nom_directori];  % for WINDOWS - for LINUX use \
    sortida = ['**  Dir: ' nom_ruta_dir ]; disp(sortida); 
     
    fitxers = dir(nom_ruta_dir);

     for(i=1:length(fitxers))
        llargaria = length(fitxers(i).name);
        if((llargaria>4)&(fitxers(i).name(llargaria-3:llargaria)=='.png'))        
            num_images = num_images +1;
            nom_im = [nom_ruta_dir '/' fitxers(i).name];   %% WINDOWS!!!!
            sortida = [' - Image ' num2str(num_images) ' : ' nom_im]; disp(sortida);                       

            PageTrain_info{num_images}.nameFile = nom_im; % the file name
            PageTrain_info{num_images}.writer = directoris(ndir).name(3:4);  % the writer number
            % compute the GLCM of each connected component in the page
            PageTrain_info{num_images}.vec_glcm_values = f_compute_glcm(nom_im);              
            PageTrain_info{num_images}.numCC = size(PageTrain_info{num_images}.vec_glcm_values,1);
			
        end
     end
  end
end
            
save('WI_BoW.mat');  

% CREATE CODEBOOK
disp('*** CREATING THE CODEBOOK  ***'); 

% concatenate all CC from all pages into one big matrix for the codebook generation
All_glcm = [];
for(i=1:num_images);
    All_glcm = vertcat(All_glcm,PageTrain_info{i}.vec_glcm_values); 
end

%size_all_glcm = size(All_glcm),

% k-means for codebook creation
[IndicesWords,GLCMcenters] = kmeans(All_glcm,nCodeWords,'MaxIter',500);
% copy the codebook into each page and create histogram
position=1;
for(i=1:num_images);
    PageTrain_info{i}.codebook = IndicesWords(position : (position+PageTrain_info{i}.numCC)-1);
    position = position +PageTrain_info{i}.numCC;
    PageTrain_info{i}.BoW = hist(PageTrain_info{i}.codebook,nCodeWords);
    % NORMALIZE for the amount of cc
    PageTrain_info{i}.BoWnorm  = 100*PageTrain_info{i}.BoW /PageTrain_info{i}.numCC;
end

save('WI_BoW.mat');  

%%%%%%%%%%%%  TEST PAGES
disp('*** TEST: COMPUTING THE DESCRIPTORS  ***'); 
name_path_dir_test = 'TestPages';

files_dir_test = dir(name_path_dir_test);
num_images_test = 0;
for(i=3:length(files_dir_test))
    llargaria = length(files_dir_test(i).name);
    if((llargaria>4)&(files_dir_test(i).name(llargaria-3:llargaria)=='.png'))        
        num_images_test = num_images_test +1;
        
        %nom_im = [nom_ruta_dir '/' files_dir(i).name];   %% LINUX!!!!
        nom_im = [name_path_dir_test '\' files_dir_test(i).name];   %% WINDOWS!!!!
        sortida = [' - Image ' num2str(num_images_test) ' : ' nom_im]; disp(sortida);     

        PageTest_info{num_images_test}.nameFile = nom_im; % the file name
        % compute the GLCM of each connected component in the page
        PageTest_info{num_images_test}.vec_glcm_values = f_compute_glcm(nom_im);              
        PageTest_info{num_images_test}.numCC = size(PageTest_info{num_images_test}.vec_glcm_values,1);  
        
        % assign codewords
        PageTest_info{num_images_test}.codebook = f_assign_codewords(PageTest_info{num_images_test}.vec_glcm_values,GLCMcenters);
        
        % create histogram
        PageTest_info{num_images_test}.BoW = hist(PageTest_info{num_images_test}.codebook,nCodeWords);
        % NORMALIZE for the amount of cc
        PageTest_info{num_images_test}.BoWnorm  = 100*PageTest_info{num_images_test}.BoW /PageTest_info{num_images_test}.numCC;
        
    end
    
end

save('WI_BoW.mat');   

disp('*** CLASSIFICATION ***');

% k-NN with n=1
for(i=1:size(PageTest_info,2))
    % compare the histograms
  
    for(j=1:size(PageTrain_info,2))
        % Euclidean distance between 2 vectors
        dist = PageTest_info{i}.BoWnorm - PageTrain_info{j}.BoWnorm;
        dist = dist .* dist;
        distances(j) = sqrt(sum(dist)); 
    end
    %distances,
    [min_value,min_id] = min(distances);
    sortida = [' - Test Image ' num2str(i) ', ' PageTest_info{i}.nameFile ' is writer: ' PageTrain_info{min_id}.writer ', min distance to page: ' PageTrain_info{min_id}.nameFile]; disp(sortida);     

end


