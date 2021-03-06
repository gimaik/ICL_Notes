function [decode] = HMMViterbiDiscrete(Y,N,T,pi, A, E)
    
    NbLatent = size(A,1);
    decode = zeros(size(Y));
    delta =  zeros(NbLatent, N, T);
    backtrack =  zeros(NbLatent, N, T);
    delta_i = zeros(NbLatent, N);
    
    
    % Taking log for all the sequences
    pi = log2(pi);
    A = log2(A);
    E=log2(E);
    
    % Initializing the delta
    delta (:,:,1) = repmat(pi, 1,N) + E(:, Y(:,1));
    
    % Filling up the delta for time t=2:T
    for k = 1: NbLatent
       for t=2: T
           for n= 1: N
               [delta_i(k,n), backtrack(k,n,t)] = max(A(:,k) + delta(:,n,t-1));      
           end
           delta(:,:,t) =  delta_i+E(:, Y(:,t));
       end
    end

    
    [M,decode(:,T)] = max(delta(:,:,T));
   
    % Decoding the delta array.
    for t=T-1:-1:1
        for n=1:N
            decode(n,t) = backtrack(decode(n,t+1),n,t+1);
        end
    end
    
    
    
end