From: akpm@linux-foundation.org
Subject: + ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 16:24:24 -0700
Message-ID: <200709132324.l8DNOOb2010962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756752AbXIMXY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 19:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam.sharma@gmail.com, tony.luck@intel.com


The patch titled
     ia64-tree-wide-misc-__cpuinitdata-init-exit fix
has been added to the -mm tree.  Its filename is
     ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64-tree-wide-misc-__cpuinitdata-init-exit fix
From: "Satyam Sharma" <satyam.sharma@gmail.com>

Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/palinfo.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/palinfo.c~ia64-tree-wide-misc-__cpuinitdata-init-exit-fix arch/ia64/kernel/palinfo.c
--- a/arch/ia64/kernel/palinfo.c~ia64-tree-wide-misc-__cpuinitdata-init-exit-fix
+++ a/arch/ia64/kernel/palinfo.c
@@ -947,7 +947,7 @@ create_palinfo_proc_entries(unsigned int
 	}
 }
 
-static void __cpuexit
+static void
 remove_palinfo_proc_entries(unsigned int hcpu)
 {
 	int j;
_

Patches currently in -mm which might be from satyam.sharma@gmail.com are

ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch
kill-declare_mutex_locked.patch
