// Copyright (c) Improbable Worlds Ltd, All Rights Reserved

using System;
using System.Collections.Generic;
using System.Text;
using System.Timers;
using Improbable;
using Improbable.Worker;

namespace Demo
{
    class Client
    {
        private const string WorkerType = "LauncherClient";
        private const string LoggerName = "LauncherClient";
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
                Console.WriteLine("Usage 1: Client local <hostname> <port> <client id>");
                Console.WriteLine("Connect to a local deployment.");
                Console.WriteLine("");
                Console.WriteLine("Usage 2: Client cloud <hostname> <player identity token> <login token>");
                Console.WriteLine("Connect to a cloud deployment.");
                Console.WriteLine("");
                Console.WriteLine("Usage 3: Client snapshot <snapshot file>");
                Console.WriteLine("Generate a snapshot and exit.");
            };

            if (arguments.Length == 2 && arguments[0] == "snapshot")
            {
                SnapshotGenerator.GenerateSnapshot(arguments[1], WorkerAttributes);
                return 0;
            }

            if (arguments.Length != 4 || (arguments[0] != "local" && arguments[0] != "cloud"))
            {
                printUsage();
                return ErrorExitStatus;
            }
            var connectToCloud = arguments[0] == "cloud";
            
            Console.WriteLine("Client Starting...");
            using (var connection = connectToCloud ? ConnectClientLocator(arguments) : ConnectClientReceptionist(arguments))
            {
                Console.WriteLine("Client connected to the deployment.");
                var dispatcher = new Dispatcher();
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
                dispatcher.OnAuthorityChange(Position.Metaclass, cb =>
                {
                    Console.WriteLine("authority change {0}", cb.Authority);
                });

                dispatcher.OnCommandResponse(PingResponder.Commands.Ping.Metaclass, response =>
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
                        connection.SendCommandRequest(PingResponder.Commands.Ping.Metaclass, entityId, new PingRequest(), CommandRequestTimeoutMS, null);
                    }
                };
                pingTimer.Start();

                while (isConnected)
                {
                    var opList = connection.GetOpList(GetOpListTimeoutInMilliseconds);
                    dispatcher.Process(opList);
                }
            }

            return 0;
        }

        private static Connection ConnectClientLocator(string[] arguments)
        {
            var hostname = arguments[1];
            var pit = arguments[2];
            var lt = arguments[3];
            
            var playerIdentityCredentials = new PlayerIdentityCredentials();
            playerIdentityCredentials.PlayerIdentityToken = pit;
            playerIdentityCredentials.LoginToken = lt;
            
            var locatorParameters = new LocatorParameters();
            locatorParameters.CredentialsType = LocatorCredentialsType.PlayerIdentity;
            locatorParameters.PlayerIdentity = playerIdentityCredentials;

            var locator = new Locator(hostname, locatorParameters);
            
            var connectionParameters = new ConnectionParameters();
            connectionParameters.WorkerType = WorkerType;
            connectionParameters.Network.ConnectionType = NetworkConnectionType.Tcp;
            connectionParameters.Network.UseExternalIp = true;
            
            using (var future = locator.ConnectAsync(connectionParameters))
            {
                return future.Get();
            }
        }

        private static Connection ConnectClientReceptionist(string[] arguments)
        {
            string hostname = arguments[1];
            ushort port = Convert.ToUInt16(arguments[2]);
            string workerId = arguments[3];
            var connectionParameters = new ConnectionParameters();
            connectionParameters.WorkerType = WorkerType;
            connectionParameters.Network.ConnectionType = NetworkConnectionType.Tcp;

            using (var future = Connection.ConnectAsync(hostname, port, workerId, connectionParameters))
            {
                return future.Get();
            }
        }

        private static void HandlePong(
            CommandResponseOp<PingResponder.Commands.Ping, Pong> response, Connection connection)
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
                        String.Format("The EntityIdResponse ID value was {0}", response.Response.Value));
                }

                connection.SendLogMessage(LogLevel.Warn, LoggerName, logMessageBuilder.ToString());
            }
            else
            {
                var workerType = response.Response.Value.workerType;
                var workerMessage = response.Response.Value.workerMessage;
                var logMessage = String.Format("New Response: {0} says \"{1}\"", workerType, workerMessage);
              
                Console.WriteLine(logMessage);
                connection.SendLogMessage(LogLevel.Info, LoggerName, logMessage);
            }
        }
    }
}
