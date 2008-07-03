From: akpm@linux-foundation.org
Subject: + gru-driver-v3-driver-makefile.patch added to -mm tree
Date: Thu, 03 Jul 2008 16:08:36 -0700
Message-ID: <200807032308.m63N8aQI032156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756202AbYGCXIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 19:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     GRU Driver: driver makefile
has been added to the -mm tree.  Its filename is
     gru-driver-v3-driver-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU Driver: driver makefile
From: Jack Steiner <steiner@sgi.com>

This patch adds the GRU driver makefile

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff -puN /dev/null drivers/misc/sgi-gru/Makefile
--- /dev/null
+++ a/drivers/misc/sgi-gru/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SGI_GRU) := gru.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
gru-driver-v3-hardware-data-structures.patch
gru-driver-v3-gru-instructions-macros.patch
gru-driver-v3-driver-internal-header-files.patch
gru-driver-v3-kernel-services-header-files.patch
gru-driver-v3-driver-initialization-file-vma-ops.patch
gru-driver-v3-page-faults-exceptions.patch
gru-driver-v3-kernel-services-provide-by-driver.patch
gru-driver-v3-resource-management.patch
gru-driver-v3-proc-interfaces.patch
gru-driver-v3-tlb-flushing-mmuops-callouts.patch
gru-driver-v3-driver-makefile.patch
gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v3-driver-misc-makefile-kconfig-changes.patch

