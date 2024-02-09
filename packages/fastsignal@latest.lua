local Metadata = {
	PackageName = 'template',
	Version = 'latest',
	Init = 'local DeferredSignal, ImmediateSignal = (function() local IsDeferred = false local bindable = Instance.new(\"BindableEvent\") local handlerRun = false bindable.Event:Connect(function() handlerRun = true end) bindable:Fire() bindable:Destroy() if handlerRun == false then IsDeferred = true end return IsDeferred and require(script.Deferred) or require(script.Immediate) end)() DeferredSignal.Deferred, DeferredSignal.Immediate = require(script.Deferred), require(script.Immediate) return DeferredSignal :: typeof(require(script.Deferred))',
    Deferred = 'local ScriptSignal,ScriptConnection,ScriptConnectionNode,FreeThread,RunHandlerInFreeThread,CreateFreeThread=(function()local ScriptSignal,ScriptConnection,ScriptConnectionNode,FreeThread,setmetatable,Instance= {},{},{},nil,setmetatable,Instance;ScriptSignal.__index,ScriptConnection.__index=ScriptSignal,ScriptConnection;local function RunHandlerInFreeThread(handler,...)local thread=FreeThread::thread FreeThread=nil handler(...)FreeThread=thread end;local function CreateFreeThread()FreeThread=coroutine.running()while true do RunHandlerInFreeThread(coroutine.yield())end end;function ScriptSignal.new()return setmetatable({_active=true,_head=nil},ScriptSignal)end;function ScriptSignal.Is(object)return typeof(object)==\"table\" and getmetatable(object)==ScriptSignal end;function ScriptSignal:IsActive()return self._active==true end;function ScriptSignal:Connect(handler)assert(typeof(handler)==\"function\",\"Must be function\")if self._active~=true then return setmetatable({Connected=false,_node=nil},ScriptConnection)end;local _head=self._head;local node={_signal=self,_connection=nil,_handler=handler,_next=_head,_prev=nil};if _head~=nil then _head._prev=node end;self._head=node;local connection=setmetatable({Connected=true,_node=node},ScriptConnection)node._connection=connection;return connection end;function ScriptSignal:Once(handler)assert(typeof(handler)==\"function\",\"Must be function\")local connection;connection=self:Connect(function(...)if connection==nil then return end connection:Disconnect()connection=nil handler(...)end)return connection end;ScriptSignal.ConnectOnce=ScriptSignal.Once;function ScriptSignal:Wait()local thread do thread=coroutine.running();local connection;connection=self:Connect(function(...)if connection==nil then return end connection:Disconnect()connection=nil task.spawn(thread,...)end)end;return coroutine.yield()end;function ScriptSignal:Fire(...)local node=self._head while node~=nil do task.defer(node._handler,...)node=node._next end end;function ScriptSignal:DisconnectAll()local node=self._head while node~=nil do local _connection=node._connection;if _connection~=nil then _connection.Connected=false;_connection._node=nil;node._connection=nil end;node=node._next end;self._head=nil end;function ScriptSignal:Destroy()if self._active~=true then return end;self:DisconnectAll()self._active=false end;function ScriptConnection:Disconnect()if self.Connected~=true then return end;self.Connected=false;local _node=self._node;local _prev=_node._prev;local _next=_node._next;if _next~=nil then _next._prev=_prev end;if _prev~=nil then _prev._next=_next else _node._signal._head=_next end;_node._connection=nil;self._node=nil end;ScriptConnection.Destroy=ScriptConnection.Disconnect;return ScriptSignal,ScriptConnection,ScriptConnectionNode,FreeThread,RunHandlerInFreeThread,CreateFreeThread end)() return ScriptSignal',
    Immediate = 'local ScriptSignal,ScriptConnection,ScriptConnectionNode,FreeThread,RunHandlerInFreeThread,CreateFreeThread=(function()local ScriptSignal,ScriptConnection,ScriptConnectionNode,FreeThread,setmetatable,Instance= {},{},{},nil,setmetatable,Instance;ScriptSignal.__index,ScriptConnection.__index=ScriptSignal,ScriptConnection;local function RunHandlerInFreeThread(handler,...)local thread=FreeThread::thread FreeThread=nil handler(...)FreeThread=thread end;local function CreateFreeThread()FreeThread=coroutine.running()while true do RunHandlerInFreeThread(coroutine.yield())end end;function ScriptSignal.new()return setmetatable({_active=true,_head=nil},ScriptSignal)end;function ScriptSignal.Is(object)return typeof(object)==\"table\" and getmetatable(object)==ScriptSignal end;function ScriptSignal:IsActive()return self._active==true end;function ScriptSignal:Connect(handler)assert(typeof(handler)==\"function\",\"Must be function\")if self._active~=true then return setmetatable({Connected=false,_node=nil},ScriptConnection)end;local _head=self._head;local node={_signal=self,_connection=nil,_handler=handler,_next=_head,_prev=nil};if _head~=nil then _head._prev=node end;self._head=node;local connection=setmetatable({Connected=true,_node=node},ScriptConnection)node._connection=connection;return connection end;function ScriptSignal:Once(handler)assert(typeof(handler)==\"function\",\"Must be function\")local connection;connection=self:Connect(function(...)connection:Disconnect()handler(...)end)return connection end;ScriptSignal.ConnectOnce=ScriptSignal.Once;function ScriptSignal:Wait()local thread do thread=coroutine.running();local connection;connection=self:Connect(function(...)connection:Disconnect()task.spawn(thread,...)end)end;return coroutine.yield()end;function ScriptSignal:Fire(...)local node=self._head while node~=nil do if node._connection~=nil then if FreeThread==nil then task.spawn(CreateFreeThread)end;task.spawn(FreeThread::thread,node._handler,...)end;node=node._next end end;function ScriptSignal:DisconnectAll()local node=self._head while node~=nil do local _connection=node._connection;if _connection~=nil then _connection.Connected=false;_connection._node=nil;node._connection=nil end;node=node._next end;self._head=nil end;function ScriptSignal:Destroy()if self._active~=true then return end;self:DisconnectAll()self._active=false end;function ScriptConnection:Disconnect()if self.Connected~=true then return end;self.Connected=false;local _node=self._node;local _prev=_node._prev;local _next=_node._next;if _next~=nil then _next._prev=_prev end;if _prev~=nil then _prev._next=_next else _node._signal._head=_next end;_node._connection=nil;self._node=nil end;ScriptConnection.Destroy=ScriptConnection.Disconnect;return ScriptSignal,ScriptConnection,ScriptConnectionNode,FreeThread,RunHandlerInFreeThread,CreateFreeThread end)() return ScriptSignal'
}

local ReplicatedStorage = game:GetService('ReplicatedStorage')

if not ReplicatedStorage:FindFirstChild('Packages') then
	error('RAMPAGE-CLI: Please run: `install kpm`.')
end

if not ReplicatedStorage.Packages:FindFirstChild('KPM') then
	error('RAMPAGE-CLI: Please run: `install kpm`.')
end

if ReplicatedStorage.Packages:FindFirstChild(Metadata.PackageName) then
	error('RAMPAGE-CLI: Package already installed, please run uninstall command.')
end

local Package = Instance.new('Folder')
Package.Name = string.format('%s@%s', Metadata.PackageName, Metadata.Version)
Package.Parent = ReplicatedStorage.Packages.KPM

local Version = Instance.new('StringValue')
Version.Name = 'Version'
Version.Value = Metadata.Version
Version.Parent = Package

local ModuleScript = Instance.new('ModuleScript')
ModuleScript.Name = 'Init'
ModuleScript.Parent = Package
ModuleScript.Source = Metadata.Init

local Deferred = Instance.new('ModuleScript')
Deferred.Name = 'Deferred'
Deferred.Parent = ModuleScript
Deferred.Source = Metadata.Deferred

local Immediate = Instance.new('ModuleScript')
Immediate.Name = 'Immediate'
Immediate.Parent = ModuleScript
Immediate.Source = Metadata.Immediate