From: akpm@linux-foundation.org
Subject: + maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch
 added to -mm tree
Date: Wed, 25 Mar 2015 15:13:54 -0700
Message-ID: <55133322.O2+gRqQNcfMiDT0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbbCYWNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 18:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.belloni@free-electrons.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Add Alexandre Belloni as an RTC maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: MAINTAINERS: Add Alexandre Belloni as an RTC maintainer

I've noticed that most of the patches for the RTC subsystem are currently
either taken directly by Andrew or going through another maintainer's
tree, quite often without an Acked-by or Reviewed-by tag.

I'd like to propose myself as the RTC susbsystem co-maintainer, to mainly
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
@@ -8141,6 +8141,7 @@ X:	kernel/torture.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
+M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
 L:	rtc-linux@googlegroups.com
 Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 S:	Maintained
_

Patches currently in -mm which might be from alexandre.belloni@free-electrons.com are

rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc.patch
rtc-add-abracon-abx80x-driver.patch
rtc-add-abracon-abx80x-driver-fix.patch
maintainers-add-alexandre-belloni-as-an-rtc-maintainer.patch
linux-next.patch

