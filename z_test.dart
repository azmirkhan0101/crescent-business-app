
var businessAnalytics = {
  "totalRedemptions": 1,
  "profileCurrent": 0,
  "profileChange": 0,
  "profileIncrease": false,
  "websiteCurrent": 0,
  "websiteChange": 0,
  "websiteIncrease": false,
  "methods": [
    {
      "method": "qr",
      "count": 0,
      "percentage": 0
    },
    {
      "method": "nfc",
      "count": 0,
      "percentage": 0
    },
    {
      "method": "static-code",
      "count": 1,
      "percentage": 100
    }
  ],
  "topRewards": [
    {
      "_id": "693cf11050d8bc24512b044a",
      "totalRedemptions": 1,
      "rewardId": "693cf11050d8bc24512b044a",
      "title": "Food reward1",
      "redemptionLimit": 67,
      "percentage": 1.49
    }
  ]
};


var getRecentActivity = {
  "success": true,
  "message": "Recent activity retrieved successfully",
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 3,
    "totalPage": 1
  },
  "data": [
    {
      "title": "Dec 9, 2025",
      "data": [
        {
          "_id": "6937c2c9e48d37fefde7eb51",
          "type": "creation",
          "timestamp": "2025-12-09T06:33:45.848Z",
          "rewardTitle": "\$25 Gift Card",
          "userName": null,
          "qrCode": null,
          "timeAgo": "2 days ago"
        }
      ]
    },
    {
      "title": "Dec 8, 2025",
      "data": [
        {
          "_id": "6936fb00af5237d44d7883ce",
          "assignedCode": "698929DDD596",
          "type": "redemption",
          "timestamp": "2025-12-08T16:21:20.919Z",
          "userName": "Mostafizur Rahaman",
          "userImage": "/images/image-1765432767234.jpg",
          "rewardTitle": "Free Tea",
          "redemptionMethod": "static-code",
          "timeAgo": "2 days ago"
        },
        {
          "_id": "6936d61243232039a271a5f3",
          "type": "creation",
          "timestamp": "2025-12-08T13:43:46.660Z",
          "rewardTitle": "Free Tea",
          "userName": null,
          "qrCode": null,
          "timeAgo": "2 days ago"
        }
      ]
    }
  ]
};


var getMyBusinessOverview = {
  "success": true,
  "message": "Business overview retrived successfully!",
  "data": {
    "overview": {
      "totalActiveRewards": 0,
      "lastSevenDaysRedeemed": 0,
      "previousSevenDaysRedeemed": 0,
      "sevenDaysGrowthPercentage": 0,
      "isIncrease": false
    },
    "monthlyStats": [
      {
        "month": "JAN 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "FEB 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "MAR 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "APR 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "MAY 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "JUN 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "JUL 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "AUG 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "SEP 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "OCT 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "NOV 2025",
        "redeemed": 0,
        "reward": 0
      },
      {
        "month": "DEC 2025",
        "redeemed": 0,
        "reward": 0
      }
    ],
    "overallProgress": {
      "totalRedemptionLimit": 0,
      "totalRedeemedCount": 0,
      "percentage": 0
    }
  }
};





class ZTest {

  var allRewardResponse = {
    "success":true,
    "message":"Business rewards retrieved successfully",
    "meta":{
      "page":1,
      "limit":10,
      "total":0,
      "totalPage":0
    },
    "data":[

    ]
  };
}


var sample = {
  "success": true,
  "message": "Business rewards retrieved successfully",
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 2,
    "totalPage": 1
  },
  "data": [
    {
      "_id": "6937c2c9e48d37fefde7eb51",
      "business": "6936d5e943232039a271a5ea",
      "title": "\$25 Gift Card",
      "description": "Redeem this \$25 gift card online or in-store.",
      "image": "/images/1-1765262025698.jpg",
      "type": "online",
      "category": "other",
      "pointsCost": 500,
      "redemptionLimit": 9,
      "redeemedCount": 0,
      "remainingCount": 9,
      "startDate": "2025-12-09T06:33:45.838Z",
      "status": "active",
      "isActive": true,
      "onlineRedemptionMethods": {
        "discountCode": true,
        "giftCard": true
      },
      "codes": [
        {
          "code": "SUMMER2024",
          "isGiftCard": false,
          "isDiscountCode": true,
          "isUsed": false
        },
        {
          "code": "https://merchant.com/redeem/abc-123-def",
          "isGiftCard": true,
          "isDiscountCode": false,
          "isUsed": false
        },
        {
          "code": "WELCOME50",
          "isGiftCard": false,
          "isDiscountCode": true,
          "isUsed": false
        },
        {
          "code": "https://merchant.com/redeem/xyz-789-ghi",
          "isGiftCard": true,
          "isDiscountCode": false,
          "isUsed": false
        },
        {
          "code": "SAVE25NOW",
          "isGiftCard": false,
          "isDiscountCode": true,
          "isUsed": false
        },
        {
          "code": "https://giftcards.com/claim?id=987654321",
          "isGiftCard": true,
          "isDiscountCode": false,
          "isUsed": false
        },
        {
          "code": "FLASH10",
          "isGiftCard": false,
          "isDiscountCode": true,
          "isUsed": false
        },
        {
          "code": "VIPMEMBER25",
          "isGiftCard": false,
          "isDiscountCode": true,
          "isUsed": false
        },
        {
          "code": "https://rewards.business.com/v/lkj-456-mnb",
          "isGiftCard": true,
          "isDiscountCode": false,
          "isUsed": false
        }
      ],
      "featured": false,
      "priority": 1,
      "views": 0,
      "redemptions": 0,
      "limitUpdateHistory": [],
      "createdAt": "2025-12-09T06:33:45.848Z",
      "updatedAt": "2025-12-09T06:33:45.848Z"
    },
    {
      "_id": "6936d61243232039a271a5f3",
      "business": "6936d5e943232039a271a5ea",
      "title": "Free Tea",
      "description": "Get a free coffee with any purchase above \$10",
      "type": "in-store",
      "category": "food",
      "pointsCost": 500,
      "redemptionLimit": 2,
      "redeemedCount": 1,
      "remainingCount": 1,
      "startDate": "2025-11-29T00:00:00.000Z",
      "expiryDate": "2025-12-31T23:59:59.000Z",
      "status": "active",
      "isActive": true,
      "inStoreRedemptionMethods": {
        "qrCode": true,
        "staticCode": true,
        "nfcTap": true
      },
      "codes": [
        {
          "code": "698929DDD596",
          "isGiftCard": false,
          "isDiscountCode": false,
          "isUsed": true,
          "redemptionId": "6936fb00af5237d44d7883ce",
          "usedAt": "2025-12-08T16:21:20.998Z",
          "usedBy": "69301feaddbf3fdf987e86e8"
        },
        {
          "code": "5CA51FC90306",
          "isGiftCard": false,
          "isDiscountCode": false,
          "isUsed": false
        }
      ],
      "featured": true,
      "priority": 10,
      "views": 7,
      "redemptions": 1,
      "limitUpdateHistory": [],
      "createdAt": "2025-12-08T13:43:46.660Z",
      "updatedAt": "2025-12-08T16:21:20.999Z"
    }
  ]
};