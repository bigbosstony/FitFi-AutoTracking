//
//  File.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-15.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import Foundation

enum Account {
    case facebook
    case email
}

struct userAccountInfoFacebook {
    var accountType: Account?
    
    var facebookID: String?
    var emailAddress: String?
    var firstName: String?
    var lastName: String?
    var age: Int?
    var gender: Int?
    var height: Int?
    var heightUnit: String = "cm"
    var weight: Int?
    var weightUnit: String = "KG"
    var password: String?
//    var profilePictureURL: String?
    
//    init(facebookID: String, emailAddress: String, firstName: String, lastName: String) {
//        self.facebookID = facebookID
//        self.emailAddress = emailAddress
//        self.firstName = firstName
//        self.lastName = lastName
//    }
}


let app_key = "eyJ0eXwqeqweqAiOiJKV1QiL2222223CJhbGciOiJ333323232323SUzI1NiIsI32323232323232mp0aSI6IjRhZTM5MGRi323232323Njl32323mNjY2323235NTNkZDQ3NmFmODY1YjI5ZTQzOGYzNGUyMGQwNzYxZTBhNGI5MDQxZjdlMzI1OGYxZDBkNDk0ZmNhYjgwYjExNzQ5In0.eyJhdWQiOiIzIiwianRpIjoiNGFlMzkwZGI2OWY2Njk1M2RkNDc2YWY4NjViMjllNDM4ZjM0ZTIwZDA3NjFlMGE0YjkwNDFmN2UzMjU4ZjFkMGQ0OTRmY2FiODBiMTE3NDkiLCJpYXQiOjE1NDc2NzMyODcsIm5iZiI6MTU0NzY3MzI4NywiZXhwIjoxNTc5MjA5Mjg3LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.r3bta-pWEUk7vIQS_C95i5lyK-NoMxNGBKq5LPw4mLNqyKltXxTgwXps-Cy5m3d12OGFfivsnFoq84yIpDxp5mKGfdfJ1_fFEevHplQcz_DlzitKyfjEwnXMqSMZkgOIRiflAUgGHI7wFe5ccBxoMVB7RXNV2lrxEAKBd-P9lR4Ol7Kv1MZICG2efzooUHUHAJuSFbnJcZozCEzrQtLqRj3RqXYP64BQ1VHiiDwMcDVoEMvWUAP8MwTgA_L6T4Bw9ZqOdq1nbV1EIWqh1XPEMnwmv-KvkKBjfDMTHzsz_pxTQiaesttBD5ex6LVbUcDtgHhdPRDKCi7mgzFTd2iMvyjlCmTXIS7Kp4Kp7XvM3kZhFdbGMA4Ep4pxL8C583H2twZ8DwChlPnhOiM6154rtbaV8J-HgWnSCMEDdu77KE3gGXr7DVnQGeRcDHNop3Upgvd9lQ4NrHostKc5lLFVadklOh5F_O38mdfMcSUN19zFWDu0aQPDDcEOQO5Pc43KWyOvXlNeO-sretKVgOmXIcxWENSV-_tMqeKIi2BM1J_DiRln878YMsGxvVw5fdCS7s0lFasdasdqKJdOT%%1TWJwHnJtVcnAhZX3GyZWaW3QxQs_csfqZpFmCohSP1znRPIJxQeGPme5JyhdKkoumhGfuUFeHj3HsRxkhOcuz9s2Sj6aY0b0"

let baseURL = "http://192.168.2.25"
let endURLCheckFBUserExist = ":81/api/checkuser_exist"

let endURLRegisterFBUser = "/api/register_user_bythirdparty"
