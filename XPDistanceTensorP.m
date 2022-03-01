%XPDISTANCETENSORP class representing a distance tensor. Using this class
%   allows us to calculate values when they are needed. Uses parfor loop to
%   speed up calculations. Requires parallel computing toolbox.
%   size: sensor x sensor x person x xyz
classdef XPDistanceTensorP < handle
    properties
        Sz
        Data
        Iset
        Accesed
        info
    end
    methods
        
        function obj =XPDistanceTensorP()
            obj.Sz = [25,25,180,3];
            obj.Data = NaN(obj.Sz);
            obj.Accesed = zeros(obj.Sz);
            for i = 1:obj.Sz(1)
                obj.Data(i,i,:,:) = 0;
            end
            obj.Iset(obj.Sz(3)).data = [];            
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
            for i = [K]
                if isempty(obj.Iset(i).data)
                    item = sprintf('/skeleton_%d/block0_values',i);
                    obj.Iset(i).data = h5read('amie/amie-kinect-data.hdf',item);
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
                                    n = n+1;
                                    index1 = sub2ind([obj.Sz(4),obj.Sz(3)],L(l),I(i));
                                    index2 = sub2ind([obj.Sz(4),obj.Sz(1)],L(l),J(j));
                                    toCalc(n).a1 = obj.Iset(K(k)).data(index1,:);
                                    toCalc(n).a2 = obj.Iset(K(k)).data(index2,:);
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
                dis = prunedDTW(normalize(toCalc(i).a1(1:200)),normalize(toCalc(i).a2(1:200)),25);
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