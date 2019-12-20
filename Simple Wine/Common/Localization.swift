import Foundation

enum Localization {
    
    case russian
    
    init() {
        self = .russian
    }
    
    enum ApiErrors {
        static var badRequestMessage: String {
            switch Localization() {
            case .russian: return "Некорректный запрос"
            }
        }
        static var badRequestTitle: String {
            switch Localization() {
            case .russian: return "Ошибка сети"
            }
        }
        static var syncErrorTitle: String {
            switch Localization() {
            case .russian: return "Ошибка синхронизации"
            }
        }
        static var syncErrorMessage: String {
            switch Localization() {
            case .russian: return "Во время синхронизации произошли ошибки. Не все данные были успешно загружены."
            }
        }
    }
    
    enum ParseErrors {
        static var parseErrorMessage: String {
            switch Localization() {
            case .russian: return "Ответ имеет неправильный формат"
            }
        }
        static var parseErrorTitle: String {
            switch Localization() {
            case .russian: return "Ошибка запроса"
            }
        }
        
        static var unsupportedPlainModel: String {
            switch Localization() {
            case .russian: return "Некорректная модель"
            }
        }
                
    }
    
    enum CacheErrors {
        static var cacheSaveErrorMessage: String {
            switch Localization() {
            case .russian: return "Произошла ошибка при сохранении данных"
            }
        }
        static var cacheSaveErrorTitle: String {
            switch Localization() {
            case .russian: return "Ошибка cохранения данных"
            }
        }
    }
    
    enum UnauthorizedAccessErrors {
        static var unauthorizedAccessErrorMessage: String {
            switch Localization() {
            case .russian: return "Пользователь не авторизован"
            }
        }
        static var unauthorizedAccessErrorTitle: String {
            switch Localization() {
            case .russian: return "Ошибка загрузки данных"
            }
        }
    }

    enum Common {
        static var article: String {
            switch Localization() {
            case .russian: return "Артикул"
            }
        }
        static var OK: String {
            switch Localization() {
            case .russian: return "OK"
            }
        }
    }

}
