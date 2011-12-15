From: akpm@linux-foundation.org
Subject: + devfreq-add-devfreq-maintainer-entry.patch added to -mm tree
Date: Thu, 15 Dec 2011 14:20:54 -0800
Message-ID: <20111215222055.0FF1D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43182 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422Ab1LOWU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 17:20:57 -0500
Received: by eaad1 with SMTP id d1so73241eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 14:20:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, khilman@ti.com, myungjoo.ham@samsung.com, rjw@sisk.pl


The patch titled
     Subject: devfreq: add devfreq maintainer entry
has been added to the -mm tree.  Its filename is
     devfreq-add-devfreq-maintainer-entry.patch

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
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: devfreq: add devfreq maintainer entry

As devfreq is merged at mainline. Also update the maintainer entry.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~devfreq-add-devfreq-maintainer-entry MAINTAINERS
--- a/MAINTAINERS~devfreq-add-devfreq-maintainer-entry
+++ a/MAINTAINERS
@@ -2187,6 +2187,13 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/usb/dwc3/
 
+DEVICE FREQUENCY (DEVFREQ)
+M:	MyungJoo Ham <myungjoo.ham@samsung.com>
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/devfreq/
+
 DEVICE NUMBER REGISTRY
 M:	Torben Mathiasen <device@lanana.org>
 W:	http://lanana.org/docs/device-list/index.html
_
Subject: Subject: devfreq: add devfreq maintainer entry

Patches currently in -mm which might be from kyungmin.park@samsung.com are

origin.patch
linux-next.patch
devfreq-add-devfreq-maintainer-entry.patch
backlight-ld9040c-regulator-control-in-the-driver.patch

