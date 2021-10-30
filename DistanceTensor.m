classdef DistanceTensor < handle
    properties
        Sz
        Data
        Iset
    end
    methods
        function obj = DistanceTensor()
            obj.Sz = [10,10,10];
            obj.Data = NaN(obj.Sz(1),obj.Sz(2),obj.Sz(3));
            for i = 1:obj.Sz(1)
                obj.Data(i,i,:) = 0;
            end
            obj.Iset(obj.Sz(1)).data = [];
            'AHHHHHHH'
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
        
        function data = calcData(obj,indices)
            IJK = {};
            for i = 1:3
                if indices{1,i}==':'
                    IJK{i} = [1:obj.Sz(i)];
                else
                    IJK{i} = indices{1,i};
                end
            end
            I = IJK{1};J=IJK{2};K=IJK{3};
            for i = [I J]
                if isempty(obj.Iset(i).data)
                    item = sprintf('/skeleton_%d/block0_values',i);
                    obj.Iset(i).data = h5read('amie/amie-kinect-data.hdf',item);
                end
            end
            data = zeros(length(I),length(J),length(K));
            for i=1:length(I)
                for j=1:length(J)
                    for k=1:length(K)
                        
                        if isnan(obj.Data(I(i),J(j),K(k)))
                            dis = dtwDistance(obj.Iset(I(i)).data(K(k),:),obj.Iset(J(j)).data(K(k),:));
                            data(i,j,k) = dis;
                            obj.Data(I(i),J(j),K(k)) = dis;
                        else
                            data(i,j,k) = obj.Data(I(i),J(j),K(k));
                        end

                    end
                end
            end

        end

    end
end