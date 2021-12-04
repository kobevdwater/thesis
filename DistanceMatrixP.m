%DISTANCETENSORP class representing a distance tensor. Using this class
%   allows us to calculate values when they are needed.
classdef DistanceMatrixP < handle
    properties
        Sz
        Data
        Iset
        Slice
        Accesed
    end
    methods
        
        function obj = DistanceMatrixP()
            obj.Sz = [50,50,20,20];
            obj.Data = NaN(obj.Sz(1),obj.Sz(2),obj.Sz(3),obj.Sz(4));
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3),obj.Sz(4));
            for i = 1:obj.Sz(1)
                for j = 1:obj.Sz(3)
                    obj.Data(i,i,j,j) = 0;
                end
            end
            obj.Iset(obj.Sz(1)).data = [];
        end

        function varargout = subsref(obj,s)
            switch s(1).type
                case '()'
                    [varargout{1:nargout}] = obj.calcData(s.subs);
                case '.'
                     [varargout{1:nargout}] = builtin('subsref',obj,s);
                otherwise
                    error('Not a valid indexing expression (yet)')
            end
        end

        function varargout = size(obj,varargin)
            [varargout{1:nargout}] = deal(obj.Sz(1)*obj.Sz(3),obj.Sz(2)*obj.Sz(4));
            %[varargout{1:nargout}] = builtin('size',this.Data,varargin{:});
        end

        function [I,J,K,L] = parseIndices(obj,indices)
            IJ = {};
            for i = 1:length(indices)
                if strcmp(indices{1,i},':')
                    IJ{i} = 1:obj.Sz(i);
                    IJ{i+2} = 1:obj.Sz(i+2);
                else
                    IJ{i} = ceil(indices{1,i}/obj.Sz(i+2));
                    IJ{i+2} = mod(indices{1,i}-1,obj.Sz(i+2))+1;
                end
            end
            I = IJ{1};J=IJ{2};K=IJ{3};L=IJ{4};
        end
        
        function data = calcData(obj,indices)
            [I,J,K,L] = obj.parseIndices(indices);
            obj.Accesed(I,J,K,L) = 1;
            for i = [I J]
                if isempty(obj.Iset(i).data)
                    item = sprintf('/skeleton_%d/block0_values',i);
                    obj.Iset(i).data = h5read('amie/amie-kinect-data.hdf',item);
                end
            end
 
            toCalc = {};
            toWrite = {};
            data = zeros(length(I),length(J),length(K),length(L));
            size(data)
            n = 0;
            m = 0;
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        for l=1:length(L)
                            if isnan(obj.Data(I(i),J(j),K(k),L(l)))
                                n = n+1;
                                toCalc(n).a1 = obj.Iset(I(i)).data(K(k),:);
                                toCalc(n).a2 = obj.Iset(J(j)).data(L(l),:);
                                toCalc(n).ijk = [i,j,k,l];
                                obj.Data(J(j),I(i),L(l),K(k)) = -1;
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
            newData = zeros(n,1);
            parfor i=1:n
            %for i=1:n
                dis = prunedDTW(normalize(toCalc(i).a1(1:200)),normalize(toCalc(i).a2(1:200)));
                newData(i) = dis;
            end
            for p=1:n
                ijk = toCalc(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);l=ijk(4);
                data(i,j,k,l) = newData(p);
                obj.Data(I(i),J(j),K(k),L(l)) = newData(p);
                obj.Data(J(j),I(i),L(l),K(k)) = newData(p);
            end
            for p=1:m
                ijk = toWrite(p).ijk;
                i=ijk(1);j=ijk(2);k=ijk(3);l=ijk(4);
                data(i,j,k,l) = obj.Data(I(i),J(j),K(k),L(l));
            end
            data = tens2mat(data,[3,1],[4,2]);
        end
        
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
            obj.Accesed = zeros(obj.Sz(1),obj.Sz(2),obj.Sz(3),obj.Sz(4));
            zr = 0;
        end
    end
end