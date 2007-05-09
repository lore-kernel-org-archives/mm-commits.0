From: akpm@linux-foundation.org
Subject: - char-mxser-schedule-for-removal.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:59 -0700
Message-ID: <200705090259.l492xxVo010479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032687AbXEIDAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, schedule for removal
has been removed from the -mm tree.  Its filename was
     char-mxser-schedule-for-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser, schedule for removal
From: Jiri Slaby <jirislaby@gmail.com>

mxser, schedule for removal

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~char-mxser-schedule-for-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~char-mxser-schedule-for-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,14 @@ be removed from this file.
 
 ---------------------------
 
+What:	MXSER
+When:	December 2007
+Why:	Old mxser driver is obsoleted by the mxser_new. Give it some time yet
+	and remove it.
+Who:	Jiri Slaby <jirislaby@gmail.com>
+
+---------------------------
+
 What:	V4L2 VIDIOC_G_MPEGCOMP and VIDIOC_S_MPEGCOMP
 When:	October 2007
 Why:	Broken attempt to set MPEG compression parameters. These ioctls are
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
