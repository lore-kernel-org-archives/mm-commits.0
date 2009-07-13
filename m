From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch added to -mm tree
Date: Mon, 13 Jul 2009 15:57:50 -0700
Message-ID: <200907132257.n6DMvo3P014149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbZGMW6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 18:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, airlied@linux.ie


The patch titled
     drivers/gpu/drm/ttm/ttm_bo_vm.c: fix misplaced parentheses
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/ttm/ttm_bo_vm.c: fix misplaced parentheses
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_bo_vm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses drivers/gpu/drm/ttm/ttm_bo_vm.c
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -327,7 +327,7 @@ ssize_t ttm_bo_io(struct ttm_bo_device *
 		goto out_unref;
 
 	kmap_offset = dev_offset - bo->vm_node->start;
-	if (unlikely(kmap_offset) >= bo->num_pages) {
+	if (unlikely(kmap_offset >= bo->num_pages)) {
 		ret = -EFBIG;
 		goto out_unref;
 	}
@@ -401,7 +401,7 @@ ssize_t ttm_bo_fbdev_io(struct ttm_buffe
 	bool dummy;
 
 	kmap_offset = (*f_pos >> PAGE_SHIFT);
-	if (unlikely(kmap_offset) >= bo->num_pages)
+	if (unlikely(kmap_offset >= bo->num_pages))
 		return -EFBIG;
 
 	page_offset = *f_pos & ~PAGE_MASK;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

