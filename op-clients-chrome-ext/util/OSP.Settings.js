/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    SINICA ALBOAIE (ROMSOFT)
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var SN_CONSTANTS ={
    FACEBOOK:{
        public:300645083384735,
        everyone:300645083384735,
        friends_of_friends:275425949243301,
        only_me:286958161406148,
        friends:291667064279714,

    }
}


var ospSettingsConfig = {

    "facebook": {
       who_can_see_future_posts: {
            read:{
                name: "Who can see your future posts?",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    public:{
                        text:"Public",
                    },
                    friends:{
                        text:"Friends"
                    },
                    only_me:{
                        text:"Only Me"
                    }
                },
                jquery_selector:{
                element:".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
           write: {
               name: "Who can see your future posts?",
               page: "https://www.facebook.com/settings?tab=privacy&section=composer&view",
               url_template: "https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=22&is_saved_on_select=true&should_return_tooltip=true&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&dpr=1",
               availableSettings: {
                   public: {
                       params: {
                           privacy_fbid: {
                               placeholder: "OPERANDO_PRIVACY_FBID",
                               value: 0
                           },
                           post_param: {
                               placeholder: "OPERANDO_POST_PARAM",
                               value: SN_CONSTANTS.FACEBOOK.public
                           }
                       },
                       name: "Public"
                   },
                   friends: {
                       params: {
                           privacy_fbid: {
                               placeholder: "OPERANDO_PRIVACY_FBID",
                               value: 0
                           },
                           post_param: {
                               placeholder: "OPERANDO_POST_PARAM",
                               value: SN_CONSTANTS.FACEBOOK.friends
                           }
                       },
                       name: "Friends"
                   },
                   only_me: {
                       params: {
                           privacy_fbid: {
                               placeholder: "OPERANDO_PRIVACY_FBID",
                               value: 0
                           },
                           post_param: {
                               placeholder: "OPERANDO_POST_PARAM",
                               value: SN_CONSTANTS.FACEBOOK.only_me
                           }
                       },
                       name: "Only Me"
                   }
               },

               data: {},
               recommended: "friends"
           }
        },
        /*activity_log:{
            read:{
                name: "Keep/delete your activity log",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Keep", "Delete"],

                jquery_selector:{

                }
            },
            write:{
                recommended:"Delete"
            }
        },*/
        /*friends_of_friends:{
            read:{
                name: "Choose if only Friends or also Friends of Friends can see your Facebook data",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Friends", "Friends of Friends"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Friends"
            }
        },*/
        /*limit_old_posts:{
            read:{
                name: "Limit (or not) viewing content on your timeline you have shared with Friends of Friends or Public, to Friends only.",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Public", "Friends of Friends", "Friends"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Friends"
            }
        },*/
        who_can_contact:{
            read:{
                name: "Choose who can contact you/send you friend requests",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    everyone:{
                        text:"Everyone",
                    },
                    friends_of_friends:{
                        text:"Friends of Friends"
                    }
                },
                jquery_selector:{
                    element :".fbSettingsList:eq(1) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can contact me?",
                page:"https://www.facebook.com/settings?tab=privacy&section=canfriend&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                availableSettings: {
                    everyone: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787540733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787540733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    }
                },
                data:{},
                recommended:"friends_of_friends"
            }
        },
        lookup_email:{
            read:{
                name: "Choose who can look you up using your email address",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    everyone:{
                        text:"Everyone",
                    },
                    friends:{
                        text:"Friends",
                    },
                    friends_of_friends:{
                        text:"Friends of Friends"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(0) ._nlm",
                    valueType:"inner"
                }
            },
            write:{
                name:"Who can look me up by email address",
                page:"https://www.facebook.com/settings?tab=privacy&section=findemail&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                availableSettings: {
                    everyone: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787820733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787820733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    },
                    friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787820733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    }
                },
                data:{},
                recommended:"friends"
            }
        },
        lookup_phone:{
            read:{
                name: "Choose  who can look you up using the phone number you provided",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:{
                    everyone:{
                        text:"Everyone",
                    },
                    friends:{
                        text:"Friends",
                    },
                    friends_of_friends:{
                        text:"Friends of Friends"
                    }
                },
                jquery_selector:{
                    element:".fbSettingsList:eq(2) .fbSettingsListItem:eq(1) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can look me up by phone",
                page:"https://www.facebook.com/settings?tab=privacy&section=findphone&view",
                url_template:"https://www.facebook.com/privacy/selector/update/?privacy_fbid={OPERANDO_PRIVACY_FBID}&post_param={OPERANDO_POST_PARAM}&render_location=11&is_saved_on_select=true&should_return_tooltip=false&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                availableSettings: {
                    everyone: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787815733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.everyone
                            }
                        },
                        name: "Everyone"
                    },
                    friends_of_friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787815733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends_of_friends
                            }
                        },
                        name: "Friends of Friends"
                    },
                    friends: {
                        params: {
                            privacy_fbid: {
                                placeholder: "OPERANDO_PRIVACY_FBID",
                                value: 8787815733
                            },
                            post_param: {
                                placeholder: "OPERANDO_POST_PARAM",
                                value: SN_CONSTANTS.FACEBOOK.friends
                            }
                        },
                        name: "Friends"
                    }
                },
                data:{},
                recommended:"friends"
            }
        },
        search_engine:{
            read:{
                name: "Allow/disallow  engines outside Facebook to link to your profile",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings: {
                    yes: {
                        text: "Yes"
                    },
                    no: {
                        text: "No"
                    }
                },
                jquery_selector:{
                    element:".fbSettingsList:eq(2) .fbSettingsListItem:eq(2) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                name:"Who can look me up by search engines",
                page:"https://www.facebook.com/settings?tab=privacy&section=search&view",
                url_template:"https://www.facebook.com/ajax/settings_page/search_filters.php?dpr=1",
                availableSettings: {
                    yes:{
                        data:{
                            "el":"search_filter_public",
                            "public":1
                        }
                    },
                    no:{
                        data:{
                            "el":"search_filter_public",
                            "public":0
                        }
                    }

                },
                data:{},
                recommended:"no"
            }
        },
        limit_timeline:{
            read:{
                name: "Limit who can add things to your timeline",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings: {
                    only_me: {
                        text: "Only Me"
                    },
                    friends: {
                        text: "Friends"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                page:"https://www.facebook.com/settings?tab=timeline&section=posting&view",
                url_template:"https://www.facebook.com/ajax/settings/timeline/posting.php?dpr=1",
                availableSettings:{
                    only_me:{
                        data:{
                            audience:10,
                        }
                    },
                    friends:{
                        data:{
                            audience:40,
                        }
                    }
                },
                data:{},
                recommended:"only_me"
            }
        },
        control_timeline:{
            read:{
                name: "Review tags people add to your own posts before the tags appear on Facebook",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings: {
                    enabled: {
                        text: "On"
                    },
                    disabled: {
                        text: "Off"
                    }
                },
                jquery_selector:{
                    element:".fbSettingsList:eq(0) .fbSettingsListItem:eq(1) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                page:"https://www.facebook.com/settings?tab=timeline&section=review&view",
                url_template:"https://www.facebook.com/ajax/settings/timeline/review.php?dpr=1",
                availableSettings: {
                    enabled: {
                        data:{
                            tag_approval_enabled:1
                        }
                    },
                    disabled: {
                        data:{
                            tag_approval_enabled:0
                        }
                    }
                },
                data:{},
                recommended:"enabled"
            }
        },
        photo_tags_audience:{
            read:{
                name: "When you are tagged in a post, whom do you want to add to the audience if they are not already in it?",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings:{
                    friends:{
                        text:"Friends"
                    },
                    only_me:{
                        text:"Only Me"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(1) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                availableSettings:{
                    only_me:{
                        data:{
                            audience:10,
                        }
                    },
                    friends:{
                        data:{
                            audience:40,
                        }
                    }
                },
                recommended:"only_me",
            }
        },
        control_tag_suggestions:{
            read:{
                name: "Control who sees tag suggestions when photos that look like you are uploaded",
                url: "https://www.facebook.com/settings?tab=timeline",
                availableSettings:{
                    friends:{
                        text:"Friends"
                    },
                    only_me:{
                        text:"Only Me"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(2) .fbSettingsListItem:eq(2) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                recommended:"only_me"
            }
        },
        control_followers:{
            read:{
                name: "Control who can be your follower.",
                url: "https://www.facebook.com/settings?tab=followers",
                availableSettings: {
                    friends: {
                        text: "Friends"
                    },
                    everyone: {
                        text: "Everyone"
                    }
                },
                jquery_selector:{
                    element: "span[class='_55pe']", //TODO: Find better way of reading value.
                    valueType: "inner"
                }
            },
            write:{
                recommended:"friends"
            }
        },
        permissions_for_apps:{
            read:{
                name: "Set permissions for data access by the apps that you use",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Friends", "Everyone"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disable all permissions"
            }
        },
        see_apps:{
            read:{
                name: "Control who on Facebook can see that you use this app",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Public", "Friends of Friends","Friends", "Only Me"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to yourself"
            }
        },
        allow_apps:{
            read:{
                name: "Allow or disallow use of apps, plugins, games and websites on Facebook and elsewhere.",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Allow", "Disallow"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        control_personal_info:{
            read:{
                name: "Control what personal info of yours your friends can bring with them when they use apps, games and websites ",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Allow", "Disallow"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not allow any"
            }
        },
        control_outdated_clients:{
            read:{
                name: "Who will see things you post using old Facebook mobile apps that do not have the inline audience selector, such as outdated versions of Facebook for BlackBerry?",
                url: "https://www.facebook.com/settings?tab=applications",
                availableSettings:["Public", "Friends of Friends","Friends", "Only Me"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to yourself"
            }
        },
        control_ads:{
            read:{
                name: "Allow or disallow Facebook to show you ads is based on your use of websites and apps that use Facebook's technologies ",
                url: "https://www.facebook.com/settings?tab=ads",
                availableSettings: {
                    allow: {
                        text: "Yes"
                    },
                    disallow: {
                        text: "No"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(0) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                recommended:"disallow"
            }
        },
        control_friends_ads:{
            read:{
                name: "Allow or disallow Facebook show ads to your friends based on actions you take, such as liking a Page or sharing a post",
                url: "https://www.facebook.com/settings?tab=ads",
                availableSettings: {
                    allow: {
                        text: "Yes"
                    },
                    disallow: {
                        text: "No"
                    }
                },
                jquery_selector:{
                    element: ".fbSettingsList:eq(1) .fbSettingsListItem:eq(0) ._nlm",
                    valueType: "inner"
                }
            },
            write:{
                recommended:"disallow"
            }
        },
        control_preferences:{
            read:{
                name: "Control preferences Facebook  created for you based on things like your profile information, actions you take on Facebook and websites and apps you use off Facebook ",
                url: "https://www.facebook.com/settings?tab=ads",
                availableSettings:["Remove all preferences", "Allow"],
                jquery_selector:{

                }
            },
            write:{
                recommended:"Remove all preferences created by Facebook"
            }
        },
        allow_email_share:{
            read:{
                name: "Allow or disallow friends to include your email address in \"download your information\"",
                url: "https://www.facebook.com/settings?tab=privacy",
                availableSettings:["Allow", "Disallow"],
                jquery_selector:{
                    //TODO: Current setting does not corresponds with actual setting in page.
                }
            },
            write:{
                recommended:"Disallow"
            }
        }

    },

    "google": {
        keep_app_activity:{
            read:{
                name: "Delete or keep all Web and app activity",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='search'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"Delete"
            }
        },
        keep_audiovideo_activity:{
            read:{
                name: "Delete or keep all Voice and Audio activity",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='audio'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"Delete"
            }
        },
        keep_device_activity:{
            read:{
                name: "Delete or keep device activity info",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='device'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"Delete"
            }
        },
        keep_location_history:{
            read:{
                name: "Delete or keep your entire location history",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='location'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"Delete"
            }
        },
        keep_youtube_history:{
            read:{
                name: "Delete or keep YouTube watch history",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='youtubeWatch'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"Delete"
            }
        },
        keep_youtube_searches:{
            read:{
                name: "Delete or keep YouTube search history",
                url: "https://myaccount.google.com/activitycontrols?pli=1",
                jquery_selector:{
                    element:"div[data-aid='youtubeSearch'] div",
                    valueType:"attrValue",
                    attrValue:"aria-checked"
                }
            },
            write:{
                recommended:"Delete"
            }
        },
        check_unused_apps:{
            read:{
                name: "Allow/disallow unused applications to access your Google data ",
                url: "https://security.google.com/settings/security/permissions",
                jquery_selector:{
                    //TODO: return a string "List has applications" or "List has n applications".
                }
            },
            write:{
                recommended:"Revoke access by unused applications"
            }
        },
        share_location:{
            read:{
                name: "Allow/disallow  sharing your location with Google and other users",
                url: "https://myaccount.google.com/privacy#accounthistory",
                jquery_selector:{
                    //TODO: Not applicable.
                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        keep_history:{
            read:{
                name: "Turn on/off Google collecting your search and browsing activity ",
                url: "https://myaccount.google.com/privacy#accounthistory",
                jquery_selector:{
                    //TODO: Not applicable.
                }
            },
            write:{
                recommended:"Off"
            }
        },
        pause_location_tracking:{
            read:{
                name: "Pause Google and related apps tracking your location. ",
                url: "https://myaccount.google.com/privacy#accounthistory",
                jquery_selector:{
                    //TODO: Not applicable.
                }
            },
            write:{
                recommended:"Pause"
            }
        },
        //TODO: Added on 22/7/2016. See if it should be kept.
        turn_off_adds_based_on_your_interest:{
            read:{
                name: "Turn off ads based on your interest",
                url: "https://www.google.com/settings/u/0/ads/authenticated",
                jquery_selector: {
                    element: "div.Pu > span.iI > div[aria-checked]",
                    valueType: "attrValue",
                    attrValue: "aria-checked"
                }
            },
            write:{
                recommended:"off"
            }
        },
    },

    "linkedin": {
        control_third_party:{
            read:{
                name: "Third party apps",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Manual review and removal of redundant apps"
            }
        },
        manage_twitter:{
            read:{
                name: "Manage your Twitter info and activity on your LinkedIn account",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not connect to Twitter"
            }
        },
        manage_wechat:{
            read:{
                name: "WeChat settings",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not connect to WeChat"
            }
        },
        share_edits:{
            read:{
                name: "Sharing profile edits",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not allow your network to be notified of your profile changes"
            }
        },
        suggest_you_email:{
            read:{
                name: "Suggesting you on the connection based on your email address",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Nobody"
            }
        },
        suggest_you_phone:{
            read:{
                name: "Suggesting you as a connection based on your phone number",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Nobody"
            }
        },
        share_data:{
            read:{
                name: "Sharing data with third parties",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"no"
            }
        },
        cookie_personalised_ads:{
            read:{
                name: "Use cookies to personalize ads",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"No"
            }
        },
        share_you_news:{
            read:{
                name: "Allow or disallow your connections and followers to know when you are mentioned in the news.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        broadcast_activity:{
            read:{
                name: "Allow or disallow your activity broadcasts.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        control_broadcast:{
            read:{
                name: "Control who can see your activity broadcast.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to yourself"
            }
        },
        control_others_see:{
            read:{
                name: "Control what others see when you have viewed their profile",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to your name and headline"
            }
        },
        how_you_rank:{
            read:{
                name: "Control showing “How You Rank”",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not allow showing how you rank"
            }
        },
        see_connections_list:{
            read:{
                name: "Select who can see your list of connections.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to yourself"
            }
        },
        control_followers:{
            read:{
                name: "Control who can follow your updates.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to your connections"
            }
        },
        control_profile_photo:{
            read:{
                name: "Control your profile photo and visibility.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:undefined
            }
        },
        control_also_viewed:{
            read:{
                name: "Control display of 'Viewers of this profile also viewed' box on your Profile page.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not display"
            }
        },
        contrl_phone_info:{
            read:{
                name: "Control how your phone number can be used.",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Limit to your 1st degree connections"
            }
        },
        meet_the_team:{
            read:{
                name: "Control “Meet the team”",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        control_messages:{
            read:{
                name: "Control the types of messages you're willing to receive",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:undefined
            }
        },
        who_can_invite:{
            read:{
                name: "Select who can send you invitations",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:undefined
            }
        },
        manage_twitter:{
            read:{
                name: "Manage your Twitter info and activity on your LinkedIn accoun",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not connect to Twitter"
            }
        },
        enable_research_invitations:{
            read:{
                name: "Turn on/off invitations to participate in research",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Off"
            }
        },
        allow_partner_inmail:{
            read:{
                name: "Allow or disallow Partner InMail",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        control_thridparty_apps:{
            read:{
                name: "Allow or disallow data sharing with 3rd party applications to which you have granted access to your LinkedIn profile and network data. ",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        control_thridparty_tracking:{
            read:{
                name: "Allow/disallow use of 3rd party site tracking",
                url: "https://www.linkedin.com/psettings/account",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        }
    },
    "twitter": {
        allow_photo_tag:{
            read:{
                name: "Allow/disallow anyone to tag you in photos",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_follow:{
            read:{
                name: "Allow anybody to follow yous",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Allow"
            }
        },
        allow_location:{
            read:{
                name: "Enable Twitter to add your location to your tweets.",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disabled"
            }
        },
        delete_locations:{
            read:{
                name: "Delete all location information from past Tweets.",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Yes"
            }
        },
        allow_photo_tag:{
            read:{
                name: "Allow/disallow anyone to tag you in photos",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_email_search:{
            read:{
                name: "Allow/disallow others find you by your email address",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_tracking:{
            read:{
                name: "Allow/disallow Twitter to tailor suggestions in your timeline (such as who to follow) based on your recent website visits",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_promoted_content:{
            read:{
                name: "Allow/disallow Twitter to display ads about things you've already shown interest in (aka “promoted content”",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_tweetdeck:{
            read:{
                name: "Allow/disallow organizations to invite anyone to tweet from their account using the teams feature in TweetDeck.",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        allow_direct_message:{
            read:{
                name: "Allow/disallow any Twitter user to send you a direct message even if you do not follow them",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Disallow"
            }
        },
        add_phone:{
            read:{
                name: "Add/do not add your phone number to Twitter",
                url: "",
                jquery_selector:{

                }
            },
            write:{
                recommended:"Do not add"
            }
        }
    }
}




function generateAngularForm(ospname){
    var schema = {
        type: "object"
    }

    schema.properties={};
    for(var v in ospSettingsConfig[ospname]){
        var conf = ospSettingsConfig[ospname][v];

        var availableSettings = conf["read"].availableSettings;
        var settingEnum = [];
        for(var key in availableSettings){
            settingEnum.push({
                value:key,
                name:availableSettings[key].text
            })
        }
        schema.properties[v] = {
            title:  conf["read"].name,
            type: "string",
            enum: conf["read"].availableSettings?settingEnum:["Yes","No"]

        };
        //schema.properties[v]["enum"].push(conf["write"]["recommended"]);
    }
    return schema;
}


function getOSPSettings(ospname){
    return ospSettingsConfig[ospname];
}


function getSettingKeyValue(osp, settingKey, settingValue){

    var availableSettings = ospSettingsConfig[osp][settingKey].read.availableSettings;

    for(key in availableSettings){
        console.log(key, availableSettings[key].text);
        if(availableSettings[key].text === settingValue){
            console.log(key);
            return key;
        }
    }

    return settingValue;

}


function getOSPs(){
    var osps = [];
    for(var v in ospSettingsConfig){
        osps.push(v);
    }
    return osps;
}

//console.log(generateAngularForm("facebook"));