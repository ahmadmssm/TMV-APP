//
//  Email.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 07/12/2023.
//  Copyright © 2023 orgName. All rights reserved.
//
// Ref: https://ttvu90.medium.com/opening-an-email-in-an-ios-application-is-a-common-feature-and-i-think-most-applications-have-it-221519e857af

import MessageUI
import kmmSharedModule

class Email: NSObject {
    
    private override init() {}
    
    func send(subject: String, body: String, to: [String]) {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        if !MFMailComposeViewController.canSendMail() {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let mails = to.joined(separator: ",")
            let alert = UIAlertController(title: "Cannot open Mail!", message: "", preferredStyle: .actionSheet)
            var haveExternalMailbox = false
            if let defaultUrl = URL(string: "mailto:\(mails)?subject=\(subjectEncoded)&body=\(bodyEncoded)"),
               UIApplication.shared.canOpenURL(defaultUrl) {
                haveExternalMailbox = true
                alert.addAction(UIAlertAction(title: "Mail", style: .default, handler: { (action) in
                    UIApplication.shared.open(defaultUrl)
                }))
            }
            if let gmailUrl = URL(string: "googlegmail://co?to=\(mails)&subject=\(subjectEncoded)&body=\(bodyEncoded)"),
               UIApplication.shared.canOpenURL(gmailUrl) {
                haveExternalMailbox = true
                alert.addAction(UIAlertAction(title: "Gmail", style: .default, handler: { (action) in
                    UIApplication.shared.open(gmailUrl)
                }))
            }
            if haveExternalMailbox {
                alert.message = "Would you like to open an external mailbox?"
            } else {
                alert.message = "Please add your mail before using the mail service."
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsUrl) {
                    alert.addAction(UIAlertAction(title: "Open Settings App", style: .default, handler: { (action) in
                        UIApplication.shared.open(settingsUrl)
                    }))
                }
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
            return
        }
        let mailCompose = MFMailComposeViewController()
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(body, isHTML: false)
        mailCompose.setToRecipients(to)
        mailCompose.mailComposeDelegate = self
        viewController.present(mailCompose, animated: true, completion: nil)
    }
}

extension Email: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension Email {
    
    static func contactSupport() {
        Email().send(subject: "", body: "", to: [BuildKonfig.shared.supportEmail])
    }
}
