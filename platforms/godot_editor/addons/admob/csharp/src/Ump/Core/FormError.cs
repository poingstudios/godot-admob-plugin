// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot.Collections;

namespace PoingStudios.AdMob.Ump.Core
{
    public class FormError
    {
        public int ErrorCode { get; set; }
        public string Message { get; set; }

        public FormError(int errorCode, string message)
        {
            ErrorCode = errorCode;
            Message = message;
        }

        public static FormError Create(Dictionary dictionary)
        {
            if (dictionary == null || dictionary.Count == 0)
                return null;

            int errorCode = (int)dictionary["error_code"];
            string message = (string)dictionary["message"];
            return new FormError(errorCode, message);
        }
    }
}
