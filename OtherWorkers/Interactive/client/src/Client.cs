// Copyright (c) Improbable Worlds Ltd, All Rights Reserved

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Text;
using System.Timers;
using Improbable;
using Improbable.Worker;

namespace Demo
{
    class Client
    {
        private const string ProjectName = "Demo";
        private const string WorkerType = "InteractiveClient";
        private const string LoggerName = "Client.cs";
        private const int ErrorExitStatus = 1;
        private const uint GetOpListTimeoutInMilliseconds = 100;
        private const uint CommandRequestTimeoutMS = 100;
        private const int pingIntervalMs = 5000;

        private static readonly EntityId[] EntityIds =
        {
            new EntityId(1),
            new EntityId(2)
        };

        private static readonly string[] WorkerAttributes = {"dice", "greetings"};

        static int Main(string[] arguments)
        {
            Action printUsage = () =>
            {
                Console.WriteLine("Usage: Client <hostname> <port> <client_id>");
                Console.WriteLine("Connects to a demo deployment.");
                Console.WriteLine("    <hostname>      - hostname of the receptionist to connect to.");
                Console.WriteLine("    <port>          - port to use.");
                Console.WriteLine("    <client_id>     - name of the client.");
                Console.WriteLine("Alternatively: Client <snapshotfile> will generate a snapshot and exit.");
            };

            if (arguments.Length != 1 && arguments.Length != 3)
            {
                printUsage();
                return ErrorExitStatus;
            }

            if (arguments.Length == 1)
            {
                SnapshotGenerator.GenerateSnapshot(arguments[0], WorkerAttributes);
                return 0;
            }

            Console.WriteLine("Client Starting...");
            using (var connection = ConnectClient(arguments))
            {
                using (var dispatcher = new Dispatcher())
                {
                    var watch = new Stopwatch();
                    watch.Start();

                    var isConnected = true;
                    var entitiesToRespond = new HashSet<EntityId>(EntityIds);

                    dispatcher.OnDisconnect(op =>
                    {
                        Console.Error.WriteLine("[disconnect] {0}", op.Reason);
                        isConnected = false;
                    });

                    dispatcher.OnLogMessage(op =>
                    {
                        connection.SendLogMessage(op.Level, LoggerName, op.Message);
                        Console.WriteLine("Log Message: {0}", op.Message);
                        if (op.Level == LogLevel.Fatal)
                        {
                            Console.Error.WriteLine("Fatal error: {0}", op.Message);
                            Environment.Exit(ErrorExitStatus);
                        }
                    });
                    dispatcher.OnAuthorityChange<Position>(cb =>
                    {
                        Console.WriteLine("authority change {0}", cb.Authority);
                    });

                    dispatcher.OnCommandResponse<PingResponder.Commands.Ping>(response =>
                    {
                        HandlePong(response, connection);
                    });

                    connection.SendLogMessage(LogLevel.Info, LoggerName,
                        "Successfully connected using TCP and the Receptionist");

                    var pingTimer = new Timer(pingIntervalMs);
                    pingTimer.Elapsed += (source, e) =>
                    {
                        foreach (var entityId in entitiesToRespond)
                        {
                            SendGetWorkerTypeCommand(connection, entityId);
                        }
                    };
                    pingTimer.Start();

                    while (isConnected)
                    {
                        var opList = connection.GetOpList(GetOpListTimeoutInMilliseconds);
                        dispatcher.Process(opList);
                    }
                }
            }

            return 0;
        }

        private static Connection ConnectClient(string[] arguments)
        {
            string hostname = arguments[0];
            ushort port = Convert.ToUInt16(arguments[1]);
            string workerId = arguments[2];
            var connectionParameters = new ConnectionParameters();
            connectionParameters.WorkerType = WorkerType;
            connectionParameters.Network.ConnectionType = NetworkConnectionType.Tcp;

            using (var future = Connection.ConnectAsync(hostname, port, workerId, connectionParameters))
            {
                return future.Get();
            }
        }

        private static void HandlePong(
            CommandResponseOp<PingResponder.Commands.Ping> response, Connection connection)
        {
            if (response.StatusCode != StatusCode.Success)
            {
                StringBuilder logMessageBuilder = new StringBuilder();
                logMessageBuilder.Append(
                    String.Format("Received invalid OnCommandResponse for request ID {0} with status code {1} to entity with ID {2}.", response.RequestId, response.StatusCode, response.EntityId));
                if (!string.IsNullOrEmpty(response.Message))
                {
                    logMessageBuilder.Append(String.Format("The message was \'{0}\'.", response.Message));
                }

                if (!response.Response.HasValue)
                {
                    logMessageBuilder.Append("The response was missing.");
                }
                else
                {
                    logMessageBuilder.Append(
                        String.Format("The EntityIdResponse ID value was {0}", response.Response.Value.Get().Value));
                }

                connection.SendLogMessage(LogLevel.Warn, LoggerName, logMessageBuilder.ToString());
            }
            else
            {
                var workerType = response.Response.Value.Get().Value.workerType;
                var workerMessage = response.Response.Value.Get().Value.workerMessage;
                var logMessage = String.Format("New Response: {0} says \"{1}\"", workerType, workerMessage);
              
                Console.WriteLine(logMessage);
                connection.SendLogMessage(LogLevel.Info, LoggerName, logMessage);
            }
        }


        private static void SendGetWorkerTypeCommand(Connection connection, EntityId entityId)
        {
            PingResponder.Commands.Ping.Request ping =
                new PingResponder.Commands.Ping.Request(new PingRequest());
            connection.SendCommandRequest(entityId, ping, CommandRequestTimeoutMS, null);
        }
    }
}
