From: akpm@linux-foundation.org
Subject: + hid-add-support-for-the-new-unibody-macbooks-fix.patch added to -mm tree
Date: Thu, 06 Nov 2008 13:26:08 -0800
Message-ID: <200811062126.mA6LQ81l028320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYKFV0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 16:26:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, dmitry.torokhov@gmail.com, jkosina@suse.cz


The patch titled
     hid: put new unibody macbooks in hid_blacklist
has been added to the -mm tree.  Its filename is
     hid-add-support-for-the-new-unibody-macbooks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: put new unibody macbooks in hid_blacklist
From: Henrik Rydberg <rydberg@euromail.se>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/hid/hid-core.c~hid-add-support-for-the-new-unibody-macbooks-fix drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-add-support-for-the-new-unibody-macbooks-fix
+++ a/drivers/hid/hid-core.c
@@ -1250,6 +1250,9 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AVERMEDIA, USB_DEVICE_ID_AVER_FM_MR800) },
_

Patches currently in -mm which might be from rydberg@euromail.se are

hwmon-applesmc-add-support-for-imac-5.patch
hwmon-applesmc-add-support-for-macbook-5.patch
hwmon-applesmc-add-support-for-macbook-pro-5.patch
hwmon-applesmc-add-support-for-imac-8.patch
hid-add-support-for-the-new-unibody-macbooks.patch
hid-add-support-for-the-new-unibody-macbooks-fix.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-map-missing-keys-to-appropriate-functions.patch

