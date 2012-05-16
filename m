From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-maintainer-for-led-subsystem.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:01 -0700
Message-ID: <20120516184701.5E5CBA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49913 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361Ab2EPSrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:02 -0400
Received: by mail-wi0-f202.google.com with SMTP id hn6so64924wib.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@canonical.com, arnd@arndb.de, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add maintainer for LED subsystem
has been removed from the -mm tree.  Its filename was
     maintainers-add-maintainer-for-led-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bryan Wu <bryan.wu@canonical.com>
Subject: MAINTAINERS: add maintainer for LED subsystem

Add Bryan Wu as the primary maintainer for drivers/leds

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-maintainer-for-led-subsystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainer-for-led-subsystem
+++ a/MAINTAINERS
@@ -4034,6 +4034,7 @@ F:	Documentation/scsi/53c700.txt
 F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
+M:	Bryan Wu <bryan.wu@canonical.com>
 M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 F:	drivers/leds/
_

Patches currently in -mm which might be from bryan.wu@canonical.com are

drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
leds-add-lm3533-led-driver.patch

