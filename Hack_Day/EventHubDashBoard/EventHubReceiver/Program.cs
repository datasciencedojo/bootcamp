using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.ServiceBus.Messaging;
using System.Threading.Tasks;

namespace EventHubReceiver
{
    class Program
    {
        static void Main(string[] args)
        {
            string eventHubConnectionString = "Endpoint=sb://sensortaghub-ns.servicebus.windows.net/;SharedAccessKeyName=all;SharedAccessKey=t4Vbmoe11DifkE7I5BAZetk0rIks6eZXNe8NOZaSlzA=";
            string eventHubName = "temperaturemonitorhub";
            string storageAccountName = "sensorstreamblob";
            string storageAccountKey = "yYU23kfrO/FKMfMghvSQK4CGMIHbnCdyxIxbe6t+gDzOjeTB7IkrPYnuGjL7v4SVzDsbdE5H9Bn6/Wyhn4Jhew==";
            string storageConnectionString = string.Format("DefaultEndpointsProtocol=https;AccountName={0};AccountKey={1}",
                        storageAccountName, storageAccountKey);

            string eventProcessorHostName = Guid.NewGuid().ToString();
            EventProcessorHost eventProcessorHost = new EventProcessorHost(eventProcessorHostName, eventHubName, EventHubConsumerGroup.DefaultGroupName, eventHubConnectionString, storageConnectionString);
            eventProcessorHost.RegisterEventProcessorAsync<SimpleEventProcessor>().Wait();

            Console.WriteLine("Receiving. Press enter key to stop worker.");
            Console.ReadLine();
        }
    }
}
