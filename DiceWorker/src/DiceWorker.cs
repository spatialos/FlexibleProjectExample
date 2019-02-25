// Copyright (c) Improbable Worlds Ltd, All Rights Reserved

using System;
using System.Reflection;
using Improbable.Worker;

namespace Demo
{
    class DiceWorker
    {
        private const string WorkerType = "DiceWorker";
        private const string LoggerName = "DiceWorker.cs";
        private const int ErrorExitStatus = 1;
        private const uint GetOpListTimeoutInMilliseconds = 100;
        private static readonly Random random = new Random();

        static int Main(string[] arguments)
        {
            Action printUsage = () =>
            {
                Console.WriteLine("Usage: DiceWorker <hostname> <port> <worker_id>");
                Console.WriteLine("Connects to the demo Flexible Project Layout project.");
                Console.WriteLine("    <hostname>      - hostname of the receptionist to connect to.");
                Console.WriteLine("    <port>          - port to use.");
                Console.WriteLine("    <worker_id>     - name of the worker assigned by SpatialOS.");
            };
            if (arguments.Length < 3)
            {
                printUsage();
                return ErrorExitStatus;
            }

            Console.WriteLine("Worker Starting...");
            using (var connection = ConnectWorker(arguments))
            {
                using (var dispatcher = new Dispatcher())
                {
                    var isConnected = true;

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

                    dispatcher.OnCommandRequest<PingResponder.Commands.Ping>(request =>
                    {
                        connection.SendLogMessage(LogLevel.Info, LoggerName, "Received GetWorkerType command");

                        var randomNumber = 4; // chosen by fair dice roll. guaranteed to be random.
                        var pingResponse = new Pong(WorkerType, String.Format("I rolled a die and got {0}!", randomNumber));
                        var commandResponse = new PingResponder.Commands.Ping.Response(pingResponse);
                        connection.SendCommandResponse(request.RequestId, commandResponse);
                    });

                    connection.SendLogMessage(LogLevel.Info, LoggerName,
                        "Successfully connected using TCP and the Receptionist");
                    while (isConnected)
                    {
                        using (var opList = connection.GetOpList(GetOpListTimeoutInMilliseconds))
                        {
                            dispatcher.Process(opList);
                        }
                    }
                }
            }

            return 0;
        }

        private static Connection ConnectWorker(string[] arguments)
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
    }
}
