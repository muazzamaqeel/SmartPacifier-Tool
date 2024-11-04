﻿using System;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using MQTTnet;
using MQTTnet.Client;
using MQTTnet.Protocol;
using Protos; // Namespace for SensorData
using SmartPacifier.BackEnd.CommunicationLayer.Protobuf;

namespace SmartPacifier.BackEnd.CommunicationLayer.MQTT
{
    /// <summary>
    /// Broker Class using Singleton Pattern. Connects to the Docker Mosquitto broker.
    /// </summary>
    public class Broker : IDisposable
    {
        private readonly string BROKER_ADDRESS = "localhost";  // Docker Mosquitto broker address
        private readonly int BROKER_PORT = 1883;               // Default MQTT port

        private static Broker? _brokerInstance;
        private static readonly object _lock = new object();

        private IMqttClient _mqttClient;
        private bool disposed = false;

        // Event handler for received messages
        public event EventHandler<MessageReceivedEventArgs>? MessageReceived;

        // Constructor for the Broker class
        private Broker()
        {
            var factory = new MqttFactory();

            // Create the MQTT client without the verbose logger
            _mqttClient = factory.CreateMqttClient();

            // Set up event handlers
            _mqttClient.ApplicationMessageReceivedAsync += OnMessageReceivedAsync;
            _mqttClient.ConnectedAsync += OnConnectedAsync;
            _mqttClient.DisconnectedAsync += OnDisconnectedAsync;
        }

        /// <summary>
        /// Dispose Method to cleanup resources.
        /// </summary>
        public void Dispose()
        {
            if (!disposed)
            {
                _mqttClient?.Dispose();
                disposed = true;
            }
            GC.SuppressFinalize(this);
        }

        // Destructor (Finalizer) in case Dispose is not called manually
        ~Broker()
        {
            Dispose();
        }

        /// <summary>
        /// Getting an Instance of the Broker. If there is no instance
        /// yet, it will create one. This is thread-safe for
        /// multithreading.
        /// </summary>
        public static Broker Instance
        {
            get
            {
                lock (_lock)
                {
                    if (_brokerInstance == null)
                    {
                        _brokerInstance = new Broker();
                    }
                    return _brokerInstance;
                }
            }
        }

        // Connect to the MQTT broker
        public async Task ConnectBroker()
        {
            var options = new MqttClientOptionsBuilder()
                .WithTcpServer(BROKER_ADDRESS, BROKER_PORT) // Connect to Docker Mosquitto
                .WithKeepAlivePeriod(TimeSpan.FromSeconds(20))
                .WithCleanSession(false)
                .Build();

            try
            {
                await _mqttClient.ConnectAsync(options);
                Console.WriteLine("Successfully connected to Docker MQTT broker.");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to connect to MQTT broker: " + ex.Message);
                throw; // Re-throw exception to be handled by caller
            }
        }

        // Subscribe to a specific topic
        public async Task Subscribe(string topic)
        {
            var topicFilter = new MqttTopicFilterBuilder()
                .WithTopic(topic)
                .WithQualityOfServiceLevel(MqttQualityOfServiceLevel.AtMostOnce) // QoS 0
                .Build();

            var subscribeResult = await _mqttClient.SubscribeAsync(topicFilter);

            Console.WriteLine($"Subscribed to topic: {topic} with QoS {topicFilter.QualityOfServiceLevel}");
            foreach (var result in subscribeResult.Items)
            {
                Console.WriteLine($"Subscription result for topic '{result.TopicFilter.Topic}': {result.ResultCode}");
            }
        }

        // Send a message to a specific topic
        public async Task SendMessage(string topic, string message)
        {
            var mqttMessage = new MqttApplicationMessageBuilder()
                .WithTopic(topic)
                .WithPayload(message)
                .WithQualityOfServiceLevel(MqttQualityOfServiceLevel.AtMostOnce) // QoS 0
                .Build();

            try
            {
                await _mqttClient.PublishAsync(mqttMessage);
                Console.WriteLine($"Message sent to topic: {topic}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to send message to topic: {topic} - {ex.Message}");
            }
        }

        // Event handler for received messages
        private async Task OnMessageReceivedAsync(MqttApplicationMessageReceivedEventArgs e)
        {
            try
            {
                // Convert the payload to a JSON string
                var payloadJson = Encoding.UTF8.GetString(e.ApplicationMessage.Payload);
                var jsonData = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(payloadJson);

                // Identify the pacifier from the topic, e.g., "Pacifier/3"
                string pacifierId = e.ApplicationMessage.Topic.Split('/')[1];

                var pacifierData = new PacifierData { PacifierId = pacifierId };

                // Populate IMU data if available
                if (jsonData.ContainsKey("acc_x"))
                {
                    pacifierData.ImuData = new IMUData
                    {
                        AccX = jsonData["acc_x"].GetSingle(),
                        AccY = jsonData["acc_y"].GetSingle(),
                        AccZ = jsonData["acc_z"].GetSingle(),
                        GyroX = jsonData["gyro_x"].GetSingle(),
                        GyroY = jsonData["gyro_y"].GetSingle(),
                        GyroZ = jsonData["gyro_z"].GetSingle(),
                        MagX = jsonData["mag_x"].GetSingle(),
                        MagY = jsonData["mag_y"].GetSingle(),
                        MagZ = jsonData["mag_z"].GetSingle()
                    };
                }

                // Populate PPG data if available
                if (jsonData.ContainsKey("led1"))
                {
                    pacifierData.PpgData = new PPGData
                    {
                        Led1 = jsonData["led1"].GetInt32(),
                        Led2 = jsonData["led2"].GetInt32(),
                        Led3 = jsonData["led3"].GetInt32(),
                        Temperature = jsonData["temperature"].GetSingle()
                    };
                }

                // Update the ExposeSensorDataManager
                ExposeSensorDataManager.Instance.UpdatePacifierData(pacifierData);

                // Log the data for this pacifier
                Console.WriteLine($"Received data for {pacifierId}");

                if (pacifierData.ImuData != null)
                {
                    Console.WriteLine($"IMU Data - AccX: {pacifierData.ImuData.AccX}, AccY: {pacifierData.ImuData.AccY}, AccZ: {pacifierData.ImuData.AccZ}");
                    Console.WriteLine($"Gyro Data - GyroX: {pacifierData.ImuData.GyroX}, GyroY: {pacifierData.ImuData.GyroY}, GyroZ: {pacifierData.ImuData.GyroZ}");
                    Console.WriteLine($"Mag Data - MagX: {pacifierData.ImuData.MagX}, MagY: {pacifierData.ImuData.MagY}, MagZ: {pacifierData.ImuData.MagZ}");
                }

                if (pacifierData.PpgData != null)
                {
                    Console.WriteLine($"PPG Data - LED1: {pacifierData.PpgData.Led1}, LED2: {pacifierData.PpgData.Led2}, LED3: {pacifierData.PpgData.Led3}, Temperature: {pacifierData.PpgData.Temperature}");
                }

                await Task.CompletedTask;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to parse message: {ex.Message}");
            }
        }

        // Event handler for successful connection
        private async Task OnConnectedAsync(MqttClientConnectedEventArgs e)
        {
            Console.WriteLine("Connected successfully with MQTT Broker.");
            await Task.CompletedTask;
        }

        // Event handler for disconnection
        private async Task OnDisconnectedAsync(MqttClientDisconnectedEventArgs e)
        {
            Console.WriteLine("Disconnected from MQTT Broker.");

            // Optionally, attempt to reconnect
            await Task.Delay(TimeSpan.FromSeconds(5));
            try
            {
                await _mqttClient.ReconnectAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Reconnection failed: " + ex.Message);
            }
        }

        // Event arguments for received messages
        public class MessageReceivedEventArgs : EventArgs
        {
            public string Topic { get; set; }
            public string Payload { get; set; }

            public MessageReceivedEventArgs(string topic, string payload)
            {
                Topic = topic;
                Payload = payload;
            }
        }
    }
}
