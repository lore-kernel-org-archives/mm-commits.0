From: akpm@linux-foundation.org
Subject: - ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch removed from -mm tree
Date: Tue, 02 Oct 2007 13:39:10 -0700
Message-ID: <200710022039.l92KdAbK021171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbXJBUjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 16:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam.sharma@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64-tree-wide-misc-__cpuinitdata-init-exit fix
has been removed from the -mm tree.  Its filename was
     ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch

This patch was dropped because it was folded into ia64-tree-wide-misc-__cpuinitdata-init-exit.patch

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

ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch
ia64-perfmon-remove-exit_pfm_fs.patch
kill-declare_mutex_locked.patch
