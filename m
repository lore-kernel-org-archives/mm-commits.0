From: akpm@linux-foundation.org
Subject: [obsolete] drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch removed from -mm tree
Date: Wed, 13 Jun 2012 12:10:47 -0700
Message-ID: <20120613191047.F191CA017E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58337 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2FMTKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 15:10:51 -0400
Received: by wgbdt11 with SMTP id dt11so57219wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 12:10:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, ngupta@vflare.org, sjenning@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/zsmalloc/zsmalloc-main.c: unbork
has been removed from the -mm tree.  Its filename was
     drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/zsmalloc/zsmalloc-main.c: unbork

complete pita :(

Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zsmalloc/zsmalloc-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/staging/zsmalloc/zsmalloc-main.c~drivers-staging-zsmalloc-zsmalloc-mainc-unbork drivers/staging/zsmalloc/zsmalloc-main.c
--- a/drivers/staging/zsmalloc/zsmalloc-main.c~drivers-staging-zsmalloc-zsmalloc-mainc-unbork
+++ a/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -240,8 +240,8 @@ static void *obj_location_to_handle(stru
 		return NULL;
 	}
 
-	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-	handle |= (obj_idx & OBJ_INDEX_MASK);
+//	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
+//	handle |= (obj_idx & OBJ_INDEX_MASK);
 
 	return (void *)handle;
 }
@@ -252,8 +252,8 @@ static void obj_handle_to_location(void 
 {
 	unsigned long hval = (unsigned long)handle;
 
-	*page = pfn_to_page(hval >> OBJ_INDEX_BITS);
-	*obj_idx = hval & OBJ_INDEX_MASK;
+//	*page = pfn_to_page(hval >> OBJ_INDEX_BITS);
+//	*obj_idx = hval & OBJ_INDEX_MASK;
 }
 
 static unsigned long obj_idx_to_offset(struct page *page,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

