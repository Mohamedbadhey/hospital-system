using System;

namespace juba_hospital
{
    /// <summary>
    /// Helper class to handle timezone conversions for the hospital system
    /// Default timezone: East Africa Time (EAT) - UTC+3
    /// 
    /// IMPORTANT: This uses a simple UTC+3 offset instead of TimeZoneInfo
    /// because the server's Windows timezone settings may not be correctly configured.
    /// </summary>
    public static class DateTimeHelper
    {
        // East Africa Time (Somalia, Kenya, Tanzania, Ethiopia, etc.)
        // UTC+3 (no daylight saving time)
        private const int EAT_OFFSET_HOURS = 3;

        /// <summary>
        /// Gets the current date and time in the hospital's timezone (East Africa Time)
        /// Use this instead of DateTime.Now throughout the application
        /// </summary>
        public static DateTime Now
        {
            get
            {
                // Always calculate from UTC to avoid server timezone issues
                return DateTime.UtcNow.AddHours(EAT_OFFSET_HOURS);
            }
        }

        /// <summary>
        /// Gets the current date in the hospital's timezone (East Africa Time)
        /// Use this instead of DateTime.Today
        /// </summary>
        public static DateTime Today
        {
            get
            {
                return Now.Date;
            }
        }

        /// <summary>
        /// Converts a UTC datetime to hospital timezone (EAT = UTC+3)
        /// </summary>
        public static DateTime ConvertFromUtc(DateTime utcDateTime)
        {
            if (utcDateTime.Kind != DateTimeKind.Utc)
            {
                utcDateTime = DateTime.SpecifyKind(utcDateTime, DateTimeKind.Utc);
            }
            return utcDateTime.AddHours(EAT_OFFSET_HOURS);
        }

        /// <summary>
        /// Converts a hospital timezone datetime to UTC
        /// </summary>
        public static DateTime ConvertToUtc(DateTime hospitalDateTime)
        {
            return hospitalDateTime.AddHours(-EAT_OFFSET_HOURS);
        }

        /// <summary>
        /// Gets the timezone offset from UTC (always +3 hours for EAT)
        /// </summary>
        public static TimeSpan GetTimezoneOffset()
        {
            return TimeSpan.FromHours(EAT_OFFSET_HOURS);
        }

        /// <summary>
        /// Gets the timezone display name
        /// </summary>
        public static string GetTimezoneName()
        {
            return "East Africa Time (EAT) - UTC+3";
        }
    }
}
