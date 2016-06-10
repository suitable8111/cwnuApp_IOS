//
//  CwnuTag.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 4..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import Foundation

class CwnuTag: NSObject {
    
    static let BOARD_POST_TYPE_BOARD = "BOARD"
    static let BOARD_POST_TYPE_BOARD_UPDATE = "BOARDUPDATE"
    static let BOARD_POST_TYPE_BOARD_COMMENT = "COMMENT"
    static let BOARD_POST_TYPE_BOARD_UPDATE_COMMET = "COMMENTUPDATE"
    
    static let BOARD_POST_TYPE_BOARD_COUNCIL = "BOARDCOUNCIL"
    static let BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE = "BOARDCOUNCILUPDATE"
    static let BOARD_POST_TYPE_BOARD_COUNCIL_COMMENT = "COMMENTCOUNCIL"
    static let BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE_COMMET = "COMMENTCOUNCILUPDATE"
    
    
    
    static let BOARD_ROW = "row"
    static let BOARD_ID = "id"
    static let BOARD_NAME = "name"
    static let BOARD_TITLE = "title"
    static let BOARD_CONTEXT = "context"
    static let BOARD_KAKAOID = "kakaoid"
    static let BOARD_KAKAOTHUMBNAIL = "kakaothumbnail"
    static let BOARD_POSTTIME = "posttime"
    static let BOARD_COMMENTCOUNT = "commentcount"
    static let BOARD_GOODCOUNT = "goodcount"
    static let BOARD_VIEWCOUNT = "viewcount"
    
    static let BOARD_COMMENT_ID = "id"
    static let BOARD_COMMENT_NAME = "name"
    static let BOARD_COMMENT_CONTEXT = "context"
    static let BOARD_COMMENT_KAKAOID = "kakaoid"
    static let BOARD_COMMENT_KAKAOTHUMBNAIL = "kakaothumbnail"
    static let BOARD_COMMENT_POSTTIME = "posttime"
    
    static let KAKAO_THUMBNAIL_IMAGE = "thumbnail_image"
    static let KAKAO_NICK = "nick"
    static let KAKAO_NICKNAME = "nickname"
    static let KAKAO_PHONE_NUM = "phonenum"
    static let KAKAO_THUMBPATH = "thumb_path"
    static let KAKAO_SCHOOLNUM = "schoolnum"
    static let KAKAO_REALNAME = "name"
    
    static let TRAFFIC_BUS_NUM = "station_num"
    static let TRAFFIC_BUS_NAME = "station_name"
    static let TRAFFIC_BUS_DETAIL = "station_detail"
    
    static let TRAFFIC_BUS_DETAIL_NUM = "ROUTE_ID"
    static let TRAFFIC_BUS_DETAIL_LEFT_TIME = "PREDICT_TRAV_TM"
    static let TRAFFIC_BUS_DETAIL_LEFT_STATION = "LEFT_STATION"

    
    static let BEST_FOOD_ID = "id"
    static let BEST_FOOD_NAME = "name"
    static let BEST_FOOD_PHONE = "phone"
    static let BEST_FOOD_INNER_IMAGE = "innerimagepath"
    static let BEST_FOOD_MENU_IMAGE = "menuimagepath"
    static let BEST_FOOD_OUTDOOR_IMAGE = "outdoorimagepath"
    static let BEST_FOOD_TYPE = "type"
    static let BEST_FOOD_CONTEXT = "context"
    static let BEST_FOOD_CAPACITY = "capacity"
    static let BEST_FOOD_OPENTIME = "opentime"
    static let BEST_FOOD_DEILVERY = "deilvery"
    static let BEST_FOOD_GOOD_COUNT = "goodcount"
    static let BEST_FOOD_LOCATION = "location"
    static let BEST_FOOD_LAT = "lat"
    static let BEST_FOOD_LNG = "long"
    
    
    static let WAGLE_ID = "boardid"
    static let WAGLE_TITLE = "title"
    static let WAGLE_DATE = "date"
    static let WAGLE_VIEW_COUNT = "count"
    static let WAGLE_NAME = "name"
    
    
    static let NOTICE_TITLE = "title"
    static let NOTICE_CONTENT = "link"
    static let NOTICE_POST_TIME = "posttime"

}