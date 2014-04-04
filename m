From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-backlight-co-maintainers.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:33:00 -0700
Message-ID: <533f08ec.IupF5OjjganOs98F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDDTdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lee.jones@linaro.org, cooloney@gmail.com, jg1.han@samsung.com

Subject: [merged] maintainers-add-backlight-co-maintainers.patch removed from -mm tree
To: jg1.han@samsung.com,cooloney@gmail.com,lee.jones@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:00 -0700


The patch titled
     Subject: MAINTAINERS: add backlight co-maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-add-backlight-co-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: MAINTAINERS: add backlight co-maintainers

Bryan Wu and Lee Jones volunteer to maintain backlight drivers and help to
setup git-tree for backlight subsystem.  Thus, I add them as backlight
co-maintainers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Bryan Wu <cooloney@gmail.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-backlight-co-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-backlight-co-maintainers
+++ a/MAINTAINERS
@@ -1704,6 +1704,8 @@ F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
 M:	Jingoo Han <jg1.han@samsung.com>
+M:	Bryan Wu <cooloney@gmail.com>
+M:	Lee Jones <lee.jones@linaro.org>
 S:	Maintained
 F:	drivers/video/backlight/
 F:	include/linux/backlight.h
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

