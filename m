From: akpm@linux-foundation.org
Subject: [merged] devfreq-add-devfreq-maintainer-entry.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:40 -0800
Message-ID: <20120111212941.0F0AC200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62274 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2AKV3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:42 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32568eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, khilman@ti.com, myungjoo.ham@samsung.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: devfreq: add devfreq maintainer entry
has been removed from the -mm tree.  Its filename was
     devfreq-add-devfreq-maintainer-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: devfreq: add devfreq maintainer entry

As devfreq is merged at mainline. Also update the maintainer entry.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~devfreq-add-devfreq-maintainer-entry MAINTAINERS
--- a/MAINTAINERS~devfreq-add-devfreq-maintainer-entry
+++ a/MAINTAINERS
@@ -2169,6 +2169,13 @@ T:	git git://git.kernel.org/pub/scm/linu
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

Patches currently in -mm which might be from kyungmin.park@samsung.com are

origin.patch
linux-next.patch

