using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.ServiceBus.Messaging;

namespace EventHubReceiver
{
    class Program
    {
        static void Main(string[] args)
        {
            string eventHubConnectionString = "Endpoint=sb://sensortaghub-ns.servicebus.windows.net/;SharedAccessKeyName=all;SharedAccessKey=T1T6DB85tsTRA0AHjrjeWR5NqT7fyPSRfD9oWepy85I=";
            string eventHubName = "dojoeventhub";
            string storageAccountName = "sensorstreamblob";
            string storageAccountKey = "4jmX7nGqlt9+Cw0Js7WR7bkIU8L6ozvdHiNZy+wYxay8TBQdAo30u8T07b0Zmw6hg2IoQN8fUhiP5F9lGVKeAA==";
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
