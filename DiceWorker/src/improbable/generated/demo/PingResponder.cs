// Generated by SpatialOS codegen. DO NOT EDIT!
// source: PingResponder in demo.schema.

namespace Demo
{

public static class PingResponder_Extensions
{
  public static PingResponder.Data Get(this global::Improbable.Worker.IComponentData<PingResponder> data)
  {
    return (PingResponder.Data) data;
  }

  public static PingResponder.Update Get(this global::Improbable.Worker.IComponentUpdate<PingResponder> update)
  {
    return (PingResponder.Update) update;
  }

  public static PingResponder.Commands.Ping.Request Get(this global::Improbable.Worker.ICommandRequest<PingResponder.Commands.Ping> request)
  {
    return (PingResponder.Commands.Ping.Request) request;
  }

  public static PingResponder.Commands.Ping.Response Get(this global::Improbable.Worker.ICommandResponse<PingResponder.Commands.Ping> response)
  {
    return (PingResponder.Commands.Ping.Response) response;
  }
}

public partial class PingResponder : global::Improbable.Worker.IComponentMetaclass
{
  public const uint ComponentId = 101;

  uint global::Improbable.Worker.IComponentMetaclass.ComponentId
  {
    get { return ComponentId; }
  }

  /// <summary>
  /// Concrete data type for the PingResponder component.
  /// </summary>
  public class Data : global::Improbable.Worker.IComponentData<PingResponder>, global::Improbable.Collections.IDeepCopyable<Data>
  {
    public global::Demo.PingResponderData Value;

    public Data(global::Demo.PingResponderData value)
    {
      Value = value;
    }

    public Data()
    {
      Value = new global::Demo.PingResponderData();
    }

    public Data DeepCopy()
    {
      return new Data(Value.DeepCopy());
    }

    public global::Improbable.Worker.IComponentUpdate<PingResponder> ToUpdate()
    {
      var update = new Update();
      return update;
    }
  }

  /// <summary>
  /// Concrete update type for the PingResponder component.
  /// </summary>
  public class Update : global::Improbable.Worker.IComponentUpdate<PingResponder>, global::Improbable.Collections.IDeepCopyable<Update>
  {
    public Update DeepCopy()
    {
      var _result = new Update();
      return _result;
    }

    public global::Improbable.Worker.IComponentData<PingResponder> ToInitialData()
    {
      return new Data(new global::Demo.PingResponderData());
    }

    public void ApplyTo(global::Improbable.Worker.IComponentData<PingResponder> _data)
    {
    }
  }

  public partial class Commands
  {
    /// <summary>
    /// Command ping.
    /// </summary>
    public partial class Ping : global::Improbable.Worker.ICommandMetaclass
    {
      public uint ComponentId { get { return 101; } }
      public uint CommandId { get { return 1; } }

      public class Request : global::Improbable.Worker.ICommandRequest<Ping>, global::Improbable.Collections.IDeepCopyable<Request>
      {
        public global::Demo.PingRequest Value;

        public Request(global::Demo.PingRequest value)
        {
          Value = value;
        }

        public Request()
        {
          Value = new global::Demo.PingRequest();
        }

        public Request DeepCopy()
        {
          return new Request(Value.DeepCopy());
        }

        public global::Improbable.Worker.Internal.GenericCommandObject ToGenericObject()
        {
          return new global::Improbable.Worker.Internal.GenericCommandObject(1, this);
        }
      }

      public class Response : global::Improbable.Worker.ICommandResponse<Ping>, global::Improbable.Collections.IDeepCopyable<Response>
      {
        public global::Demo.Pong Value;

        public Response(global::Demo.Pong value)
        {
          Value = value;
        }

        public Response(
            string workerType,
            string workerMessage)
        {
          Value = new global::Demo.Pong(
              workerType,
              workerMessage);
        }

        public Response DeepCopy()
        {
          return new Response(Value.DeepCopy());
        }

        public global::Improbable.Worker.Internal.GenericCommandObject ToGenericObject()
        {
          return new global::Improbable.Worker.Internal.GenericCommandObject(1, this);
        }
      }
    }
  }

  // Implementation details below here.
  //----------------------------------------------------------------

  public global::Improbable.Worker.Internal.ComponentProtocol.ComponentVtable Vtable {
    get {
      global::Improbable.Worker.Internal.ComponentProtocol.ComponentVtable vtable;
      vtable.ComponentId = ComponentId;
      vtable.Free = global::System.Runtime.InteropServices.Marshal
          .GetFunctionPointerForDelegate(global::Improbable.Worker.Internal.ClientHandles.ClientFree);
      vtable.Copy = global::System.Runtime.InteropServices.Marshal
          .GetFunctionPointerForDelegate(global::Improbable.Worker.Internal.ClientHandles.ClientCopy);
      vtable.Deserialize = global::System.Runtime.InteropServices.Marshal
          .GetFunctionPointerForDelegate(clientDeserialize);
      vtable.Serialize = global::System.Runtime.InteropServices.Marshal
          .GetFunctionPointerForDelegate(clientSerialize);
      return vtable;
    }
  }

  public void InvokeHandler(global::Improbable.Worker.Dynamic.Handler handler)
  {
    handler.Accept<PingResponder>(this);
  }

  private static unsafe readonly global::Improbable.Worker.Internal.ComponentProtocol.ClientDeserialize
      clientDeserialize = ClientDeserialize;
  private static unsafe readonly global::Improbable.Worker.Internal.ComponentProtocol.ClientSerialize
      clientSerialize = ClientSerialize;

  [global::Improbable.Worker.Internal.MonoPInvokeCallback(typeof(global::Improbable.Worker.Internal.ComponentProtocol.ClientDeserialize))]
  private static unsafe global::System.Byte
  ClientDeserialize(global::System.UInt32 componentId,
                    global::System.Byte handleType,
                    global::Improbable.Worker.Internal.Pbio.Object* root,
                    global::Improbable.Worker.Internal.ComponentProtocol.ClientHandle** handleOut)
  {
    *handleOut = null;
    try
    {
      *handleOut = global::Improbable.Worker.Internal.ClientHandles.HandleAlloc();
      if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Update) {
        var data = new Update();
        **handleOut = global::Improbable.Worker.Internal.ClientHandles.Instance.CreateHandle(data);
      }
      else if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Snapshot)
      {
        var data = new Data(global::Demo.PingResponderData_Internal.Read(
            global::Improbable.Worker.Internal.Pbio.GetObject(root, 101)));
        **handleOut = global::Improbable.Worker.Internal.ClientHandles.Instance.CreateHandle(data);
      }
      else if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Request)
      {
        var data = new global::Improbable.Worker.Internal.GenericCommandObject();
        **handleOut = global::Improbable.Worker.Internal.ClientHandles.Instance.CreateHandle(data);
        var commandObject = global::Improbable.Worker.Internal.Pbio.GetObject(root, 101);
        if (global::Improbable.Worker.Internal.Pbio.GetObjectCount(commandObject, 1) != 0) {
          data.CommandId = 1;
          data.CommandObject = new Commands.Ping.Request(global::Demo.PingRequest_Internal.Read(global::Improbable.Worker.Internal.Pbio.GetObject(commandObject, 1)));
          return 1;
        }
        return 0;
      }
      else if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Response)
      {
        var data = new global::Improbable.Worker.Internal.GenericCommandObject();
        **handleOut = global::Improbable.Worker.Internal.ClientHandles.Instance.CreateHandle(data);
        var commandObject = global::Improbable.Worker.Internal.Pbio.GetObject(root, 101);
        if (global::Improbable.Worker.Internal.Pbio.GetObjectCount(commandObject, 2) != 0) {
          data.CommandId = 1;
          data.CommandObject = new Commands.Ping.Response(global::Demo.Pong_Internal.Read(global::Improbable.Worker.Internal.Pbio.GetObject(commandObject, 2)));
          return 1;
        }
        return 0;
      }
    }
    catch (global::System.Exception e)
    {
      global::Improbable.Worker.ClientError.LogClientException(e);
      return 0;
    }
    return 1;
  }

  [global::Improbable.Worker.Internal.MonoPInvokeCallback(typeof(global::Improbable.Worker.Internal.ComponentProtocol.ClientSerialize))]
  private static unsafe void
  ClientSerialize(global::System.UInt32 componentId,
                  global::System.Byte handleType,
                  global::Improbable.Worker.Internal.ComponentProtocol.ClientHandle* handle,
                  global::Improbable.Worker.Internal.Pbio.Object* root)
  {
    try
    {
      var _pool = global::Improbable.Worker.Internal.ClientHandles.Instance.GetGcHandlePool(*handle);
      if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Update) {
        global::Improbable.Worker.Internal.Pbio.AddObject(
            global::Improbable.Worker.Internal.Pbio.AddObject(root, /* entity_state */ 2), 101);
      }
      else if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Snapshot) {
        var data = (Data) global::Improbable.Worker.Internal.ClientHandles.Instance.Dereference(*handle);
        global::Demo.PingResponderData_Internal.Write(_pool, data.Value, global::Improbable.Worker.Internal.Pbio.AddObject(root, 101));
      }
      else if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Request)
      {
        var data = (global::Improbable.Worker.Internal.GenericCommandObject)
            global::Improbable.Worker.Internal.ClientHandles.Instance.Dereference(*handle);
        var commandObject = global::Improbable.Worker.Internal.Pbio.AddObject(root, 101);
        if (data.CommandId == 1)
        {
          var requestObject = (Commands.Ping.Request) data.CommandObject;
          {
            global::Demo.PingRequest_Internal.Write(_pool, requestObject.Value, global::Improbable.Worker.Internal.Pbio.AddObject(commandObject, 1));
          }
        }
      }
      else if (handleType == (byte) global::Improbable.Worker.Internal.ComponentProtocol.ClientHandleType.Response)
      {
        var data = (global::Improbable.Worker.Internal.GenericCommandObject)
            global::Improbable.Worker.Internal.ClientHandles.Instance.Dereference(*handle);
        var commandObject = global::Improbable.Worker.Internal.Pbio.AddObject(root, 101);
        if (data.CommandId == 1)
        {
          var responseObject = (Commands.Ping.Response) data.CommandObject;
          {
            global::Demo.Pong_Internal.Write(_pool, responseObject.Value, global::Improbable.Worker.Internal.Pbio.AddObject(commandObject, 2));
          }
        }
      }
    }
    catch (global::System.Exception e)
    {
      global::Improbable.Worker.ClientError.LogClientException(e);
    }
  }
}

}
