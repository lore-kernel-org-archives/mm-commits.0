From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipcshm-document-new-limits-in-the-uapi-header-v3.patch removed from -mm
 tree
Date: Fri, 06 Jun 2014 14:09:09 -0700
Message-ID: <53922df5.UH1T/KKTlwotm4iD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaFFVJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, manfred@colorfullife.com, davidlohr@hp.com

Subject: [folded-merged] ipcshm-document-new-limits-in-the-uapi-header-v3.patch removed from -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:09:09 -0700


The patch titled
     Subject: ipcshm-document-new-limits-in-the-uapi-header-v3
has been removed from the -mm tree.  Its filename was
     ipcshm-document-new-limits-in-the-uapi-header-v3.patch

This patch was dropped because it was folded into ipcshm-document-new-limits-in-the-uapi-header.patch

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipcshm-document-new-limits-in-the-uapi-header-v3

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header-v3 include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header-v3
+++ a/include/uapi/linux/shm.h
@@ -8,13 +8,13 @@
 #endif
 
 /*
- * SHMMNI, SHMMAX and SHMALL are the default upper limits which can be
- * modified by sysctl. Both SHMMAX and SHMALL have their default values
- * to the maximum limit which is as large as it can be without helping
- * userspace overflow the values. There is really nothing the kernel
- * can do to avoid this any further. It is therefore not advised to
- * make them any larger. These limits are suitable for both 32 and
- * 64-bit systems.
+ * SHMMNI, SHMMAX and SHMALL are default upper limits which can be
+ * modified by sysctl. The SHMMAX and SHMALL values have been chosen to
+ * be as large possible without facilitating scenarios where userspace
+ * causes overflows when adjusting the limits via operations of the form
+ * "retrieve current limit; add X; update limit". It is therefore not
+ * advised to make SHMMAX and SHMALL any larger. These limits are
+ * suitable for both 32 and 64-bit systems.
  */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

