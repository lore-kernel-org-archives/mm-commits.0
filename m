From: akpm@linux-foundation.org
Subject: [merged] mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:06 -0400
Message-ID: <201005191732.o4JHWWlv025745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268Ab0ESRcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, mm-commits@vger.kernel.org


The patch titled
     mptscsih: fix first line of kernel-doc for a few functions
has been removed from the -mm tree.  Its filename was
     mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mptscsih: fix first line of kernel-doc for a few functions
From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a short
description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions
+++ a/drivers/message/fusion/mptscsih.c
@@ -2570,9 +2570,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTE
 }
 
 /**
- * mptscsih_set_scsi_lookup
- *
- * writes a scmd entry into the ScsiLookup[] array list
+ * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
  *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
@@ -2735,7 +2733,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 
 /**
- *	mptscsih_get_completion_code -
+ *	mptscsih_get_completion_code - get completion code from MPT request
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mmc-add-support-mmcif-for-superh.patch
staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

