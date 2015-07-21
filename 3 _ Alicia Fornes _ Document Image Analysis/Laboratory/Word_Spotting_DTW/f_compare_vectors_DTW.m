function [ distance_cost,m_PD,m_previous_pos ] = f_compare_vectors_DTW( v1_in,v2_in )

% example
%[ cost, m_PD, m_positions ] = f_compare_vectors_DTW([2,3,6,1,1,5], [2,3,6,0,0,3,5])

    % the vectors must be vertical
    if(size(v1_in,1)==1)
        v1_in = v1_in';
    end
    if(size(v2_in,1)==1)
        v2_in = v2_in';
    end

    v1 = f_elimina_zeros_final_vector(v1_in);
    v2 = f_elimina_zeros_final_vector(v2_in);

    % Compare every row in v1 with every row in v2
    n_values_row_v1 = 1;
    n_values_row_v2 = 1;
    [ncol_v1]=length(v1);
    [ncol_v2]=length(v2);
    
    % Inicialize the matrix for Dynamic Programming
    m_PD=zeros(ncol_v1,ncol_v2);
    % Save the path, store the previous position
    m_previous_pos.r(1:ncol_v1,1:ncol_v2)=0;  
    m_previous_pos.c(1:ncol_v1,1:ncol_v2)=0;
    % Fill the first row
    m_PD(1,1) = f_euclideanDist2(v1(1),v2(1));
    m_previous_pos.r(1,1)=0; m_previous_pos.c(1,1)=0;
    for(i=2:ncol_v2)
        m_PD(1,i)= m_PD(1,i-1) + f_euclideanDist2(v1(1),v2(i));
        m_previous_pos.r(1,i)=1;  m_previous_pos.c(1,i)=i-1;
    end
    % Fill the first column
    for(i=2:ncol_v1)
        m_PD(i,1)= m_PD(i-1,1) + f_euclideanDist2(v1(i),v2(1));
        m_previous_pos.r(i,1)=i-1; m_previous_pos.c(i,1)=1;
    end
    
    % Fill the matrix
    for(row=2:ncol_v1)
        for(col=2:ncol_v2)
            values(1)=m_PD(row-1,col-1);
            values(2)=m_PD(row,col-1);
            values(3)=m_PD(row-1,col);
   
            % If tie, then the diagonal movement is priotary => substitution
            the_minimum = find(values == min(values));

            m_PD(row,col) = values(the_minimum(1)) + f_euclideanDist2(v1(row),v2(col));

            switch the_minimum(1)
                case 2,
                    m_previous_pos.r(row,col) = row;     m_previous_pos.c(row,col) = col-1;
                case 3,
                    m_previous_pos.r(row,col) = row-1;   m_previous_pos.c(row,col) = col;
                case 1,
                    m_previous_pos.r(row,col) = row-1;   m_previous_pos.c(row,col) = col-1;
            end
        end
    end
    
    % The solution is the last position in the matrix
    % divided for the lenght of the path
    length_path = f_compute_length_path(m_previous_pos,ncol_v1,ncol_v2);
    distance_cost= (m_PD(ncol_v1,ncol_v2) / length_path);     
    

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cami] = f_compute_length_path(m,n1,n2)

row = n1;
column = n2;
cami = 0;
while ((row>0)&&(column>0))
    aux = m.r(row,column);
    column = m.c(row,column);
    row = aux;
    cami = cami+1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [m_out] = f_elimina_zeros_final_vector(m)

    suma = sum(m,2);
    pos =length(suma);
    while(suma(pos)==0)
        pos = pos-1;
    end
    
    m_out = m(1:pos);   



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [d_euclid_2] = f_euclideanDist2(v1,v2)
    % Euclidean distance (square) between 2 vectors
    d1 = v1-v2;
    d2 = d1 .* d1;
    d_euclid_2 = sum(d2);
    
    
    