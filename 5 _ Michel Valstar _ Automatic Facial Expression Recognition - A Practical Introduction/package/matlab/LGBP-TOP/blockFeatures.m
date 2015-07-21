function features = blockFeatures(I, ki, kj, mode, mapping)
% compute the catenated feature vector
%
% AUTHOR:	B.H. Jiang
% CREATED:	2010.8.13
%
%IN:  I: full image, in which blocks will be defined by ki and kj
%IN:  ki, kj: number of columns respectively rows to divide image into regions 
%IN:  mode: 'lbp' or 'lpq' or 'rilpq'


    % feature extraction
    Wi = size(I,1)/ki;
    Wj = size(I,2)/kj;

    [nf nf_block] = featureDimensions(mode, ki, kj);
    features = zeros(1, nf);

    % computer features for each block
    cnt = 1;
    for Region_i=1:ki
        i_start = (Region_i-1)*Wi+1;
        i_end = Region_i*Wi;
        for Region_j=1:kj
          j_start = (Region_j-1)*Wj+1;
          j_end = Region_j*Wj;
          img = I(round(i_start):round(i_end),round(j_start):round(j_end));
            switch mode
				case 'histogram'
					
					if isstruct(mapping)
    					bins = mapping.num;
    					for i = 1:size(img,1)
        					for j = 1:size(img,2)
            					img(i,j) = mapping.table(img(i,j)+1);
        					end
    					end
					end
					
					h = hist(img(:),0:(bins-1));
					h=h/sum(h);
				
                case 'lbp'
                    %mapping = getmapping(8,'u2');   % Uniform LBP  
                    h = lbp(img,1,8,mapping,'nh'); % set the radius and num of neighbor
                case 'rilpq'
                    LPQfilters=createLPQfilters(9); % rotation Invariant LPQ
                    charOri=charOrientation(img);           % LPQ
                    h=ri_lpq(img,LPQfilters,charOri); 
                case 'lpq'
                    h = lpq(img,3);
                case 'gaborpyramid'
                    %[h1 h2] = phasesym(img);
                    h = gaborHist(img, 5, 6, 3, 2.1, ...
                                    0.55, 1.2, 0);
                                
                    h = h/sum(h);
                case 'gabor'
                    [h1 h2] = phasesym(img);
                    h = h1/sum(h1);
                case 'dct_bb'
                    b = dct2(img);
                    h = reshape(b,1,[]);
                    h = h/sum(h);
                case 'dctpyramid'
                    b = dct2(img);
                    h = reshape(b,1,[]);
                    bins = [-0.0387497288094507,-0.0259819459109761,-0.0173881033053051,-0.0116036901994191,-0.00771027062975331,-0.00508965628773283,-0.00332575198543000,-0.00213848900751179,-0.00133935643728394,-0.000801469821869767,-0.000439424747221870,-0.000195736519404799,-3.17128755687976e-05,7.86894855884884e-05,0.000153000000000000,0.000227310514411512,0.000337712875568798,0.000501736519404799,0.000745424747221871,0.00110746982186977,0.00164535643728394,0.00244448900751179,0.00363175198543000,0.00539565628773283,0.00801627062975331,0.0119096901994191,0.0176941033053051,0.0262879459109761,0.0390557288094507];
                    h = hist(h,bins);
                    h = h/sum(h);
                otherwise
                    error('undefined method\n');
            end
            features(cnt:cnt+nf_block-1) = h; 
            cnt = cnt + nf_block;
        end 
    end
end
% 
function [n s] = featureDimensions(mode, a, b)
% -- Calculates feature dimensionality
% OUT: n is nr of total features, s is nr features per block
    switch mode
		case 'histogram'
			s = 59;
        case 'lbp'
            s = 59;
        case 'lpq'
            s = 256;
        case 'rilpq'
            s = 0;
        case 'gabor'
            s = 30;
        case 'gaborpyramid'
            s = 30;
        case 'dctpyramid'
            s = 29;
        case 'dct_bb'
            s = 13*13; %need to change later
    end
    n = a*b*s;
end