// Copyright (c) Improbable Worlds Ltd, All Rights Reserved

using System;
using System.Reflection;
using Improbable.Worker;

namespace Demo
{
    class HelloWorker
    {
        private const string WorkerType = "HelloWorker";
        private const string LoggerName = "HelloWorker.cs";
        private const int ErrorExitStatus = 1;
        private const uint GetOpListTimeoutInMilliseconds = 100;
        private static readonly string[] hellos = {
            "Hello", "Bonjour", "Ciao", "Guten Tag", "nĭ hăo" // A selection of Greetings in arbitrary languages
        };
        private static readonly Random random = new Random();

        static int Main(string[] arguments)
        {
            Action printUsage = () =>
            {
                Console.WriteLine("Usage: " + WorkerType + " <hostname> <port> <worker_id>");
                Console.WriteLine("Connects to the deployment.");
                Console.WriteLine("    <hostname>      - hostname of the receptionist to connect to.");
                Console.WriteLine("    <port>          - port to use.");
                Console.WriteLine("    <worker_id>     - name of the worker assigned by SpatialOS.");
            };
            if (arguments.Length < 3)
            {
                printUsage();
                return ErrorExitStatus;
            }

            Assembly.Load("GeneratedCode");

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

                        var greeting = hellos[random.Next(hellos.Length)];
                        var pingResponse = new Pong(WorkerType, String.Format("{0}, World!", greeting));
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
