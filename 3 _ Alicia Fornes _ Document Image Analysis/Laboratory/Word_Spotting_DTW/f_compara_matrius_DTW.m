function [ distancia_final,m_anterior ] = f_compara_matrius_DTW( m1_in,m2_in )


    m1 = f_elimina_zeros_final_matriu(m1_in);
    m2 = f_elimina_zeros_final_matriu(m2_in);
    
    % Compare every row in matrix m1 with every row in matrix m2
    [ncol_m1, n_valors_f_m1]=size(m1);
    [ncol_m2, n_valors_f_m2]=size(m2);
    
    % Inicialization
    m_PD=zeros(ncol_m1,ncol_m2);
    m_anterior.f(1:ncol_m1,1:ncol_m2)=0;  % Save the path
    m_anterior.c(1:ncol_m1,1:ncol_m2)=0;
    % Fill first row
    m_PD(1,1) = f_dist_euclidea2(m1(1,:),m2(1,:));
    m_anterior.f(1,1)=0; m_anterior.c(1,1)=0;
    for(i=2:ncol_m2)
        m_PD(1,i)= m_PD(1,i-1) + f_dist_euclidea2(m1(1,:),m2(i,:));
        m_anterior.f(1,i)=1;  m_anterior.c(1,i)=i-1;
    end
    % Fill first column
    for(i=2:ncol_m1)
        m_PD(i,1)= m_PD(i-1,1) + f_dist_euclidea2(m1(i,:),m2(1,:));
        m_anterior.f(i,1)=i-1; m_anterior.c(i,1)=1;
    end
    

    % Fill the matrix
    for(fil=2:ncol_m1)
        for(col=2:ncol_m2)
            valors(1)=m_PD(fil,col-1);
            valors(2)=m_PD(fil-1,col);
            valors(3)=m_PD(fil-1,col-1);
            el_minim = find(valors == min(valors));
            m_PD(fil,col) = valors(el_minim(1)) + f_dist_euclidea2(m1(fil,:),m2(col,:));
            switch el_minim(1)
                case 1,
                    m_anterior.f(fil,col) = fil;     m_anterior.c(fil,col) = col-1;
                case 2,
                    m_anterior.f(fil,col) = fil-1;   m_anterior.c(fil,col) = col;
                case 3,
                    m_anterior.f(fil,col) = fil-1;   m_anterior.c(fil,col) = col-1;
            end
        end
    end
    
    % Divide the final cost by the path length
    llarg = f_llargaria_cami(m_anterior,ncol_m1,ncol_m2);
    distancia_final= (m_PD(ncol_m1,ncol_m2) / llarg);     
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [m_out] = f_elimina_zeros_final_matriu(m);

    suma = sum(m,2);
    pos =length(suma);
    while(suma(pos)==0)
        pos = pos-1;
    end
    
    m_out = m(1:pos,:);   



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cami] = f_llargaria_cami(m,n1,n2)

fila = n1;
columna = n2;
cami = 0;
while ((fila>0)&&(columna>0))
    aux = m.f(fila,columna);
    columna = m.c(fila,columna);
    fila = aux;
    cami = cami+1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [d_euclid_2] = f_dist_euclidea2(v1,v2)
    % Square Euclidean Distance
    d1 = v1-v2;
    d2 = d1 .* d1;
    d_euclid_2 = sum(d2);
    
    
    