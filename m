From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-2.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:05:46 -0700
Message-ID: <55f0ad3a.uZlJIQZ3gsKEvQlw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbbIIWFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: fix IDLE_PAGE_TRACKING dependencies
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-2.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm/Kconfig: fix IDLE_PAGE_TRACKING dependencies

Fixes: proc-add-kpageidle-file
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~proc-add-kpageidle-file-fix-2 mm/Kconfig
--- a/mm/Kconfig~proc-add-kpageidle-file-fix-2
+++ a/mm/Kconfig
@@ -651,6 +651,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
+	depends on PROC_FS && MMU
 	select PROC_PAGE_MONITOR
 	select PAGE_EXTENSION if !64BIT
 	help
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-3.patch
proc-add-kpageidle-file-fix-4.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

