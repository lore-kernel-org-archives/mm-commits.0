From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:18:02 -0700
Message-ID: <553550ea.EiRGIYzKhfOLdSy8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbbDTTLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.belloni@free-electrons.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Add Alexandre Belloni as an RTC maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: MAINTAINERS: Add Alexandre Belloni as an RTC maintainer

I've noticed that most of the patches for the RTC subsystem are currently
either taken directly by Andrew or going through another maintainer's
tree, quite often without an Acked-by or Reviewed-by tag.

I'd like to propose myself as the RTC subsystem co-maintainer, to mainly
help Alessandro reviewing incoming patches and maintain a subsystem tree
to avoid having the RTC patches going through trees when they have no
particular dependencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-alexandre-belloni-as-an-rtc-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-alexandre-belloni-as-an-rtc-maintainer
+++ a/MAINTAINERS
@@ -8183,6 +8183,7 @@ X:	kernel/torture.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
+M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
 L:	rtc-linux@googlegroups.com
 Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 S:	Maintained
_

Patches currently in -mm which might be from alexandre.belloni@free-electrons.com are

origin.patch
documentation-bindings-add-abraconabx80x.patch
rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc.patch
linux-next.patch

