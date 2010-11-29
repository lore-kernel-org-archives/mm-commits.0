From: akpm@linux-foundation.org
Subject: [merged] kernel-power-changed-makefile-to-use-proper-ccflag-flag.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:41 -0800
Message-ID: <201011291952.oATJqA6i007368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0K2T6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, lenb@kernel.org, mmarek@suse.cz, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     kernel/power/Makefile: use proper ccflag flag
has been removed from the -mm tree.  Its filename was
     kernel-power-changed-makefile-to-use-proper-ccflag-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/power/Makefile: use proper ccflag flag
From: Tracey Dent <tdent48227@gmail.com>

Use the ccflags-$ flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/power/Makefile~kernel-power-changed-makefile-to-use-proper-ccflag-flag kernel/power/Makefile
--- a/kernel/power/Makefile~kernel-power-changed-makefile-to-use-proper-ccflag-flag
+++ a/kernel/power/Makefile
@@ -1,7 +1,4 @@
