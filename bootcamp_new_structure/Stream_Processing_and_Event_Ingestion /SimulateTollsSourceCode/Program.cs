//------------------------------------------------------------------------------
// <copyright>
//     Copyright (c) Microsoft Corporation. All Rights Reserved.
// </copyright>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using Microsoft.ServiceBus.Messaging;
using Newtonsoft.Json;

namespace TollApp
{
    public class Program
    {
        private static Timer timer;

        public static void Main()
        {
            var r = new Random();
            var eh = EventHubClient.CreateFromConnectionString("Endpoint=sb://kztest.servicebus.windows.net/;SharedAccessKeyName=AnomalyDetection;SharedAccessKey=Ji/mN7F5t97vAQ/HxNeWUpMsYdPZys/d/dAGs2cN0+Q=", "adtest2");

            if (string.IsNullOrEmpty(Environment.EventHubConnectionString))
            {
                Console.WriteLine("Please specify Service Bus connection string in the App.config file");
                return;
            }

            while (true)
            {
                Console.WriteLine("1. Setup input sources");
                Console.WriteLine("2. Send toll data to Event Hub");
                Console.WriteLine("3. Cleanup");
                Console.WriteLine("4. Exit");

                Console.WriteLine("\nChoose action 1-4:");

                var action = Console.ReadLine();

                switch (action)
                {
                    case "1":
                        Environment.Setup();
                        break;
                    case "2":
                        Console.WriteLine("Service Bus Connection String to Namespace with RootManageSharedAccessKey:");
                        string serviceBusConnectionString = Console.ReadLine();

                        Console.WriteLine("Name of the event hub to send entry signals.");
                        string entryHub = Console.ReadLine();
                        
                        Console.WriteLine("Name of the event hub to send exit signals.");
                        string exitHub = Console.ReadLine();

                        SendData(serviceBusConnectionString, entryHub, exitHub);

                        // Old method of sending data.
                        //SendData(Environment.EventHubConnectionString, Environment.EntryEventHubPath, Environment.ExitEventHubPath);
                        break;
                    case "3":
                        Environment.Cleanup();
                        break;
                    case "4":
                        return;
                }

                Console.WriteLine("\n\n");
            }
        }

        public static void SendData(string serviceBusConnectionString, string entryHubName, string exitHubName, bool addPolicy = false)
        {
            var entryEventHub = EventHubClient.CreateFromConnectionString(serviceBusConnectionString, entryHubName);
            var exitEventHub = EventHubClient.CreateFromConnectionString(serviceBusConnectionString, exitHubName);
           
            var timerInterval = TimeSpan.FromSeconds(1);
            var generator = TollDataGenerator.Generator();

            if (addPolicy)
            {
                EventHubHelper.AddManagementPolicy(serviceBusConnectionString, entryHubName);
                EventHubHelper.AddManagementPolicy(serviceBusConnectionString, exitHubName);
            }

            TimerCallback timerCallback = state =>
            {
                var startTime = DateTime.UtcNow;
                generator.Next(startTime, timerInterval, 5);

                foreach (var e in generator.GetEvents(startTime))
                {
                    if (e is EntryEvent)
                    {
                        Console.WriteLine(
                            "Entry Time: " + e.EntryTime.ToString()
                            + " | Entry Booth: " + e.TollId.ToString()
                            + " | LicensePlate: " + e.LicensePlate.ToString());
                        entryEventHub.Send(
                           new EventData(Encoding.UTF8.GetBytes(e.Format()))
                            {
                                PartitionKey = e.TollId.ToString()
                            });
                    }
                    else
                    {
                        exitEventHub.Send(
                           new EventData(Encoding.UTF8.GetBytes(e.Format()))
                           {
                               PartitionKey = e.TollId.ToString()
                           });
                    }
                }

                timer.Change((int)timerInterval.TotalMilliseconds, Timeout.Infinite);
            };

            timer = new Timer(timerCallback, null, Timeout.Infinite, Timeout.Infinite);
            timer.Change(0, Timeout.Infinite);

            Console.WriteLine("Sending event hub data... Press Ctrl+c to stop.");

            var exitEvent = new ManualResetEvent(false);
            Console.CancelKeyPress += (sender, eventArgs) =>
            {
                eventArgs.Cancel = true;
                exitEvent.Set();
            };

            exitEvent.WaitOne();

            timer.Change(Timeout.Infinite, Timeout.Infinite);
            Thread.Sleep(timerInterval);
            timer.Dispose();
            entryEventHub.Close();
            exitEventHub.Close();
        }
    }
}
