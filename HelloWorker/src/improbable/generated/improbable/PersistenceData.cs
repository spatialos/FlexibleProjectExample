// Generated by SpatialOS codegen. DO NOT EDIT!
// source: improbable.PersistenceData in improbable/standard_library.schema.

namespace Improbable
{

public partial struct PersistenceData : global::System.IEquatable<PersistenceData>, global::Improbable.Collections.IDeepCopyable<PersistenceData>
{
  public static PersistenceData Create()
  {
    var _result = new PersistenceData();
    return _result;
  }

  public PersistenceData DeepCopy()
  {
    var _result = new PersistenceData();
    return _result;

  }

  public override bool Equals(object _obj)
  {
    return _obj is PersistenceData && Equals((PersistenceData) _obj);
  }

  public static bool operator==(PersistenceData a, PersistenceData b)
  {
    return a.Equals(b);
  }

  public static bool operator!=(PersistenceData a, PersistenceData b)
  {
    return !a.Equals(b);
  }

  public bool Equals(PersistenceData _obj)
  {
    return true;
  }

  public override int GetHashCode()
  {
    int _result = 1327;
    return _result;
  }
}

public static class PersistenceData_Internal
{
  public static unsafe void Write(global::Improbable.Worker.Internal.GcHandlePool _pool,
                                  PersistenceData _data, global::Improbable.Worker.Internal.Pbio.Object* _obj)
  {
  }

  public static unsafe PersistenceData Read(global::Improbable.Worker.Internal.Pbio.Object* _obj)
  {
    PersistenceData _data;
    return _data;
  }
}

}
