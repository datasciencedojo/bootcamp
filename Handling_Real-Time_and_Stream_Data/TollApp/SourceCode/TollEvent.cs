//------------------------------------------------------------------------------
// <copyright>
//     Copyright (c) Microsoft Corporation. All Rights Reserved.
// </copyright>
//------------------------------------------------------------------------------

using System;
using System.Text;

namespace TollApp
{
    public abstract class TollEvent
    {
        public int TollId { get; set; }

        public string LicensePlate { get; set; }

        public abstract string Format();
    }

    public class EntryEvent : TollEvent
    {
        public EntryEvent(int tollId, DateTime entryTime, string licence, string state, CarModel carModel, double tollAmount, int tag)
        {
            this.TollId = tollId;
            this.EntryTime = entryTime;
            this.LicensePlate = licence;
            this.State = state;
            this.CarModel = carModel;
            this.TollAmount = tollAmount;
            this.Tag = tag;
        }

        public DateTime EntryTime { get; set; }

        public CarModel CarModel { get; set; }

        public string State { get; set; }

        public double TollAmount { get; set; }

        public long Tag { get; set; }

        public override string Format()
        {
            var sb = new StringBuilder();
            sb.AppendLine(@"TollId,EntryTime,LicensePlate,State,Make,Model,VehicleType,VehicleWeight,Toll,Tag");
            sb.AppendLine(
                string.Join(
                    ",",
                    this.TollId.ToString(),
                    this.EntryTime.ToString(),
                    this.LicensePlate,
                    this.State,
                    this.CarModel.Make,
                    this.CarModel.Model,
                    this.CarModel.VehicleType.ToString(),
                    this.CarModel.VehicleWeight.ToString(),
                    this.TollAmount.ToString(),
                    this.Tag.ToString()));

            return sb.ToString();
        }
    }

    public class ExitEvent : TollEvent
    {
        public ExitEvent(int tollId, DateTime exitTime, string licence)
        {
            this.TollId = tollId;
            this.ExitTime = exitTime;
            this.LicensePlate = licence;
        }

        public DateTime ExitTime { get; set; }

        public override string Format()
        {
            var sb = new StringBuilder();
            sb.AppendLine(@"TollId,ExitTime,LicensePlate");
            sb.AppendLine(
                string.Join(
                    ",",
                    this.TollId.ToString(),
                    this.ExitTime.ToString(),
                    this.LicensePlate));
            return sb.ToString();
        }
    }

    public class CarModel
    {
        public readonly string Make;
        public readonly string Model;
        public readonly int VehicleType;
        public readonly double VehicleWeight;

        public CarModel(string make, string model, int vehicleType, double vehicleWeight)
        {
            Model = model;
            Make = make;
            VehicleType = vehicleType;
            VehicleWeight = vehicleWeight;
        }
    }
}
