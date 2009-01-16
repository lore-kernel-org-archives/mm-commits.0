From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-entry-for-freezer.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:02 -0800
Message-ID: <200901161917.n0GJH2PL025597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936742AbZAPTRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add entry for freezer
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-freezer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add entry for freezer
From: Pavel Machek <pavel@suse.cz>

Now that people are using freezer for non-suspend/hibernation stuff, it
should have separate maintainers entry so that it is easier to find.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-freezer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-freezer
+++ a/MAINTAINERS
@@ -1821,6 +1821,14 @@ M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 
+FREEZER
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
 FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
nbd-trivial-cleanups.patch

