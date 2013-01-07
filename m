From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-drivers-media-usb-dvb-usb-cxusb.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:16 -0800
Message-ID: <20130107192616.A93CA820059@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40021 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3AGT0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:17 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so2114205vcd.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, mkrufky@linuxtv.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
has been removed from the -mm tree.  Its filename was
     maintainers-fix-drivers-media-usb-dvb-usb-cxusb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*

This driver was never at dvb-usb-v2, as far as I could see.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-media-usb-dvb-usb-cxusb MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-media-usb-dvb-usb-cxusb
+++ a/MAINTAINERS
@@ -2632,7 +2632,7 @@ W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-F:	drivers/media/usb/dvb-usb-v2/cxusb*
+F:	drivers/media/usb/dvb-usb/cxusb*
 
 DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

