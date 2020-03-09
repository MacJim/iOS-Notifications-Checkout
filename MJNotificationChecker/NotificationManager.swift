import Foundation
import UserNotifications


// To conform to the `UNUserNotificationCenterDelegate` protocol, I'll need to derive this class from `NSObject`.
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    //MARK: - Singleton stuff.
    private static let singleton = NotificationManager()
    
    class var shared: NotificationManager {
        return NotificationManager.singleton
    }
    
    
    // MARK: - Initializers
    fileprivate override init() {
        super.init()
        askForPermission()
    }
    
    
    // MARK: - Notifications permission
    // Source: https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
    func askForPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            // First run: allow: `true` and `nil`; don't allow: `false` and `nil`.
            // Later runs: allow: `true` and `nil`; don't allow: `false` and `nil`.
            granted, error in
            print("Notification permission granted: \(granted)")
            
            if (granted) {
                center.delegate = self
            }
        }
    }
    
    
    // MARK: - Send notifications
    // Source: https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
    // MARK: Triggers
    private func createCalendarRecurringTrigger(repeats: Bool, weekDay: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> UNCalendarNotificationTrigger {
        // Create the date component of the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.weekday = weekDay
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        
        return trigger
    }
    
    private func createTimeIntervalTrigger(repeats: Bool, timeInterval: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        
        return trigger
    }
    
    // MARK: Register notifications (base)
    private func registerNotificationWithTrigger(title: String, body: String, identifier: String, trigger: UNNotificationTrigger) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings() {
            settings in
            if (settings.authorizationStatus == .authorized) {
                // Send the notification.
                // Create the notification content.
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.badge = 1
                content.sound = .default
                
                // Create and Register a notification request.
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) {
                    error in
                    if let error = error {
                        print("Error sending notification:", error)
                    }
                }
            }
        }
    }
    
    // MARK: Register notifications (convenience)
    /// Sends a notification after a specific time interval.
    func sendNotificationAfterTimeInterval(title: String, body: String, timeInterval: TimeInterval) {
        let trigger = createTimeIntervalTrigger(repeats: false, timeInterval: timeInterval)
        registerNotificationWithTrigger(title: title, body: body, identifier: "Test", trigger: trigger)
    }
    
    func registerRecurringNotificationsOnDates(title: String, body: String, identifier: String, weekDay: Int?, hour: Int?, minute: Int?, second: Int?) {
        
    }
    
    
    // MARK: - Unregister notifications
    // Source: https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/1649517-removependingnotificationrequest
    func unregisterNotification() {
        let center = UNUserNotificationCenter.current()
        // For some reasons the following lines doesn't work.
//        center.removePendingNotificationRequests(withIdentifiers: ["Test"])
//        center.removeAllPendingNotificationRequests()
    }
    
    
    // MARK: - Notifications while the app runs in the foreground
    // Source: https://developer.apple.com/documentation/usernotifications/handling_notifications_and_notification-related_actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification identifier:", notification.request.identifier)
        completionHandler([.alert, .sound, .badge])
        
        // If you want to supress the notification, use this.
//        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
}

