%DTAmieY4 class representing a 4D distance tensor of the Amie dataset.
%Y(i,j,k,l) = distance between persons i and j based on sensor k on repetition l.
%The data in the tensor can be accesed via normal indexing. 
%   e.g. Y(:,1,1,1) will result in a fiber.
%The percentage of the elements that are calculated can be calculated via 
%   Y.getSampleRate()
%   Indexing can be used to find the samplerate of that part of the tensor.
%   e.g. Y.getSampleRate(:,:,1,1) will give the sampling in the first slice.
% All 'persons' containing less than 8 repetitions are removed. 
classdef DTAmieY4 < handle
    properties
        Sz
        Data
        Iset
        Accesed
        indexset
        amieLoc
    end
    methods
        
        function obj =DTAmieY4(amieLoc)
            obj.Sz = [180,180,75,8];
            obj.Data = NaN(obj.Sz);
            obj.Accesed = zeros(obj.Sz);
            obj.amieLoc = amieLoc;
            for i = 1:obj.Sz(1)
                obj.Data(i,i,:,:) = 0;
            end
            obj.Iset(187*100).data = [];
            %Removing all samples that contain less than 8 repetitions.
            obj.indexset = 1:185; 
            obj.indexset(152) = []; %6
            obj.indexset(151) = []; %1
            obj.indexset(71) = []; %6
            obj.indexset(36) = []; %6
            obj.indexset(7) = [];            
            
        end

        function sref = subsref(obj,s)
            switch s(1).type
                case '()'
                    sref = obj.calcData(s.subs);
                case '.'
                     sref = builtin('subsref',obj,s);
                otherwise
                    error('Not a valid indexing expression (yet)')
            end
        end

        function varargout = size(this,varargin)
            [varargout{1:nargout}] = builtin('size',this.Data,varargin{:});
        end

        %Transform the indices given in to a form that can be used to
        %calculate data.
        function [I,J,K,L] = parseIndices(obj,indices)
            IJKL = {};
            for i = 1:length(indices)
                if strcmp(indices{1,i},':')
                    IJKL{i} = [1:obj.Sz(i)];
                else
                    IJKL{i} = indices{1,i};
                end
            end
            I = IJKL{1};J=IJKL{2};K=IJKL{3};L=IJKL{4};
        end
        
        function data = calcData(obj,indices)
            [I,J,K,L] = obj.parseIndices(indices);
            obj.Accesed(I,J,K,L) = 1;
            %load the needed data
            for i = [I J]
                for j = L
                    ii = obj.indexset(i);
                    index = 100*ii+j;
                    obj.Iset(index);
                    if isempty(obj.Iset(index).data)
                        item = sprintf('/skeleton_%d/block0_values',index);
                        obj.Iset(index).data = h5read(obj.amieLoc+"split.hdf",item);
                    end
                end
            end
 
            toCalc = {};
            toWrite = {};
            data = zeros(length(I),length(J),length(K));
            n = 0;
            m = 0;
            %Find all indices that have to be calculated. If the data has
            %been calculated before, it will be copied and not calculated
            %again.
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        for l=1:length(L)
                                if isnan(obj.Data(I(i),J(j),K(k),L(l)))
                                    ii = obj.indexset(I(i));
                                    jj = obj.indexset(J(j));
                                    n = n+1;
                                    index1 = ii*100+L(l);
                                    index2 = jj*100+L(l);
                                    toCalc(n).a1 = obj.Iset(index1).data(K(k),:);
                                    toCalc(n).a2 = obj.Iset(index2).data(K(k),:);
                                    toCalc(n).ijk = [i,j,k,l];
                                    obj.Data(J(j),I(i),K(k),L(l)) = -1;
                                elseif obj.Data(I(i),J(j),K(k),L(l)) == -1
                                    m=m+1;
                                    toWrite(m).ijk = [i,j,k,l];
                                else
                                    data(i,j,k,l) = obj.Data(I(i),J(j),K(k),L(l));
                                end
                        end
                    end
                end
            end
            %Calculate the data that has to be calculated.
            newData = zeros(n,1);
            parfor i=1:n
%                 dis = dtwDistance(normalize(toCalc(i).a1),normalize(toCalc(i).a2),10);
                dis = dtw(normalize(toCalc(i).a1),normalize(toCalc(i).a2))
                newData(i) = dis;
            end
            %Place the newly calculated data in output structure and in the
            %internal datastructure used to remember calculated data.
            for p=1:n
                ijk = toCalc(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);l=ijk(4);
                data(i,j,k,l) = newData(p);
                obj.Data(I(i),J(j),K(k),L(l)) = newData(p);
                obj.Data(J(j),I(i),K(k),L(l)) = newData(p);
            end
            %Place the previously calculated data in the output structure.
            for p=1:m
                ijk = toWrite(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);ijk(4);
                data(i,j,k) = obj.Data(I(i),J(j),K(k),L(l));
            end
        end
        
        %Check how many data elements are accessed.
        % Only the indices given will be counted. If no indices are given,
        % the whole matrix will be concidered.
        function sr = getSampleRate(obj,varargin)
            if isempty(varargin)
                sr = sum(obj.Accesed,'all')/(prod(obj.Sz));
            else
                [I,J,K,L] = obj.parseIndices(varargin);
                totalSum = sum(obj.Accesed(I,J,K,L),'all');
                sr = totalSum/(length(I)*length(J)*length(K)*length(L));
            end
        end
        
        function zr = resetSamplingRate(obj)
            obj.Accesed = zeros(obj.Sz);
            zr = 0;
        end
    end
end