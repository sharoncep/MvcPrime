using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OfficeOpenXml.Utils
{
    /// <summary>
    /// 
    /// </summary>
    public class ValidationResult : IValidationResult
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="result"></param>
        public ValidationResult(bool result)
            : this(result, null)
        {
            
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="result"></param>
        /// <param name="errorMessage"></param>
        public ValidationResult(bool result, string errorMessage)
        {
            _result = result;
            _errorMessage = errorMessage;
        }

        private bool _result;
        private string _errorMessage;

        private void Throw()
        {
            if(string.IsNullOrEmpty(_errorMessage))
            {
                throw new InvalidOperationException();
            }
            throw new InvalidOperationException(_errorMessage);
        }

        void IValidationResult.IsTrue()
        {
            if (!_result)
            {
                Throw();
            }
        }

        void IValidationResult.IsFalse()
        {
            if (_result)
            {
                Throw();
            }
        }
    }
}
