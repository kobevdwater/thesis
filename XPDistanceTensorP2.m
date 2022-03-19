%XPDISTANCETENSORP class representing a distance tensor. Using this class
%   allows us to calculate values when they are needed. Uses parfor loop to
%   speed up calculations. Requires parallel computing toolbox.
%   size: sensor x sensor x person x xyz
classdef XPDistanceTensorP2 < handle
    properties
        Sz
        Data
        Iset
        Accesed
        indexset
    end
    methods
        
        function obj =XPDistanceTensorP2()
            obj.Sz = [25,25,180,3,8];
            obj.Data = NaN(obj.Sz);
            obj.Accesed = zeros(obj.Sz);
            for i = 1:obj.Sz(1)
                obj.Data(i,i,:) = 0;
            end
            obj.Iset(187*100).data = [];
%             obj.Slice = NaN;
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
        function [I,J,K,L,M] = parseIndices(obj,indices)
            IJKL = {};
            for i = 1:length(indices)
                if strcmp(indices{1,i},':')
                    IJKL{i} = [1:obj.Sz(i)];
                else
                    IJKL{i} = indices{1,i};
                end
            end
            I = IJKL{1};J=IJKL{2};K=IJKL{3};L=IJKL{4};M=IJKL{5};
        end
        
        function data = calcData(obj,indices)
            [I,J,K,L,M] = obj.parseIndices(indices);
            obj.Accesed(I,J,K,L,M) = 1;
            %load the needed data
            for k = K
                for m=M
                    index = 100*obj.indexset(k)+m;
                    if isempty(obj.Iset(index).data)
                        item = sprintf('/skeleton_%d/block0_values',index);
                        obj.Iset(index).data = h5read('amie/split.hdf',item);
                    end
                end
            end
 
            toCalc = {};
            toWrite = {};
            data = zeros(length(I),length(J),length(K));
            n = 0;
            o = 0;
            %Find all indices that have to be calculated. If the data has
            %been calculated before, it will be copied and not calculated
            %again.
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        for l=1:length(L)
                            for m=1:length(M)
                                if isnan(obj.Data(I(i),J(j),K(k),L(l),M(m)))
                                    n = n+1;
                                    kk=obj.indexset(K(k));
                                    index = kk*100+M(m);
                                    sens1 = sub2ind([obj.Sz(4),obj.Sz(1)],L(l),I(i));
                                    sens2 = sub2ind([obj.Sz(4),obj.Sz(2)],L(l),J(j));
                                    toCalc(n).a1 = obj.Iset(index).data(sens1,:);
                                    toCalc(n).a2 = obj.Iset(index).data(sens2,:);
                                    toCalc(n).ijk = [i,j,k,l,m];
                                    obj.Data(J(j),I(i),K(k),L(l),M(m)) = -1;
                                elseif obj.Data(I(i),J(j),K(k),L(l),M(m)) == -1
                                    o=o+1;
                                    toWrite(o).ijk = [i,j,k,l,m];
                                else
                                    data(i,j,k,l,m) = obj.Data(I(i),J(j),K(k),L(l),M(m));
                                end
                            end
                        end
                    end
                end
            end
            %Calculate the data that has to be calculated.
            newData = zeros(n,1);
            for i=1:n
                dis = prunedDTW(normalize(toCalc(i).a1),normalize(toCalc(i).a2),5);
                newData(i) = dis;
            end
            %Place the newly calculated data in output structure and in the
            %internal datastructure used to remember calculated data.
            for p=1:n
                ijk = toCalc(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);l=ijk(4);m=ijk(5);
                data(i,j,k,l,m) = newData(p);
                obj.Data(I(i),J(j),K(k),L(l),M(m)) = newData(p);
                obj.Data(J(j),I(i),K(k),L(l),M(m)) = newData(p);
            end
            %Place the previously calculated data in the output structure.
            for p=1:o
                ijk = toWrite(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);ijk(4);m=ijk(5);
                data(i,j,k,m) = obj.Data(I(i),J(j),K(k),L(l),M(m));
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