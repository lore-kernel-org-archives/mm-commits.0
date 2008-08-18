From: akpm@linux-foundation.org
Subject: - abituguru3-update-maintainers.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:01 -0700
Message-ID: <200808181940.m7IJe1HU008415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765286AbYHRTlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alistair@devzero.co.uk, j.w.r.degoede@hhs.nl, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     abituguru3: update MAINTAINERS
has been removed from the -mm tree.  Its filename was
     abituguru3-update-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: abituguru3: update MAINTAINERS
From: Alistair John Strachan <alistair@devzero.co.uk>

Hans passed maintainership of the abituguru3 hwmon driver onto me.  Add a
new entry to the MAINTAINERS file for the abituguru3 driver and assign it
to me.  Also update the existing UGURU entry to indicate that Hans is only
responsible for the abituguru driver.

Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
Acked-by: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~abituguru3-update-maintainers MAINTAINERS
--- a/MAINTAINERS~abituguru3-update-maintainers
+++ a/MAINTAINERS
@@ -175,12 +175,18 @@ M:	bcrl@kvack.org
 L:	linux-aio@kvack.org
 S:	Supported
 
-ABIT UGURU HARDWARE MONITOR DRIVER
+ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 P:	Hans de Goede
 M:	j.w.r.degoede@hhs.nl
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
+ABIT UGURU 3 HARDWARE MONITOR DRIVER
+P:	Alistair John Strachan
+M:	alistair@devzero.co.uk
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+
 ACENIC DRIVER
 P:	Jes Sorensen
 M:	jes@trained-monkey.org
_

Patches currently in -mm which might be from alistair@devzero.co.uk are

origin.patch

