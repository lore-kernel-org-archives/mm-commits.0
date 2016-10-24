From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 24 Oct 2016 12:04:02 -0700
Message-ID: <580e5b22.Sqc3408W4viXeF0U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941264AbcJXTEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~linux-next-git-rejects drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -575,11 +575,7 @@ static int vmw_user_dmabuf_synccpu_grab(
 		long lret;
 
 		lret = reservation_object_wait_timeout_rcu(bo->resv, true, true,
-<<<<<<< HEAD
-					nonblock ? 0 : MAX_SCHEDULE_TIMEOUT);
-=======
 							   nonblock ? 0 : MAX_SCHEDULE_TIMEOUT);
->>>>>>> linux-next/akpm-base
 		if (!lret)
 			return -EBUSY;
 		else if (lret < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

