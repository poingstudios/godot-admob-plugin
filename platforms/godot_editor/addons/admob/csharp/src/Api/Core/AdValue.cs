// MIT License
//
// Copyright (c) 2023-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdValue
    {
        public enum PrecisionType
        {
            Unknown = 0,
            Estimated = 1,
            PublisherProvided = 2,
            Precise = 3
        }
        public string CurrencyCode { get; }
        public PrecisionType Precision { get; }
        public long ValueMicros { get; }

        public AdValue(string currencyCode, PrecisionType precision, long valueMicros)
        {
            CurrencyCode = currencyCode;
            Precision = precision;
            ValueMicros = valueMicros;
        }

        public static AdValue Create(Dictionary adValueDictionary)
        {
            var currencyCode = (string)adValueDictionary["currency_code"];
            var precisionType = (PrecisionType)(int)adValueDictionary["precision_type"];
            var valueMicros = (long)adValueDictionary["value_micros"];

            return new AdValue(currencyCode, precisionType, valueMicros);
        }
    }
}
