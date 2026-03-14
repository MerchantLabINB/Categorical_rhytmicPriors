function d=JSD(P,Q)
    assert(numel(P)==numel(Q));
    assert(sum(size(P)==size(Q))==length(size(P)));
    P=P(:);
    Q=Q(:);
    P=P/sum(P);
    Q=Q/sum(Q);
    M=(P+Q)/2;
    d= (DKL(P,M)+DKL(Q,M))/2;
    

    