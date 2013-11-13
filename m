From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-richard-purdie-as-backlight-maintainer.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:40:24 -0800
Message-ID: <5283e3b8.607i7IQdKrjVRnZM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rpurdie@rpsys.net, jg1.han@samsung.com

Subject: [merged] maintainers-remove-richard-purdie-as-backlight-maintainer.patch removed from -mm tree
To: jg1.han@samsung.com,rpurdie@rpsys.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:24 -0800


The patch titled
     Subject: MAINTAINERS: remove Richard Purdie as backlight maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-remove-richard-purdie-as-backlight-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: MAINTAINERS: remove Richard Purdie as backlight maintainer

Remove Richard Purdie as backlight subsystem maintainer,

akpm: Richard is still responsive and is reviewing some of the patches,
but appears to agree that listing him as the maintainer is no longer
appropriate.

[akpm@linux-foundation.org: s/USA/UK/]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    5 +++++
 MAINTAINERS |    1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN CREDITS~maintainers-remove-richard-purdie-as-backlight-maintainer CREDITS
--- a/CREDITS~maintainers-remove-richard-purdie-as-backlight-maintainer
+++ a/CREDITS
@@ -2895,6 +2895,11 @@ S: Framewood Road
 S: Wexham SL3 6PJ
 S: United Kingdom
 
+N: Richard Purdie
+E: rpurdie@rpsys.net
+D: Backlight subsystem maintainer
+S: United Kingdom
+
 N: Daniel Quinlan
 E: quinlan@pathname.com
 W: http://www.pathname.com/~quinlan/
diff -puN MAINTAINERS~maintainers-remove-richard-purdie-as-backlight-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-richard-purdie-as-backlight-maintainer
+++ a/MAINTAINERS
@@ -1661,7 +1661,6 @@ S:	Maintained
 F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
-M:	Richard Purdie <rpurdie@rpsys.net>
 M:	Jingoo Han <jg1.han@samsung.com>
 S:	Maintained
 F:	drivers/video/backlight/
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

