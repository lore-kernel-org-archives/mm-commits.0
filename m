From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 12 Dec 2016 16:25:04 -0800
Message-ID: <584f3fe0.lUjmBiZDWlwcqUhQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932451AbcLMAYU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:24:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-rmap-handle-anon_vma_prepare-common-case-inline.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes

WARNING: function definition argument 'struct vm_area_struct *' should also have an identifier name
#45: FILE: include/linux/rmap.h:140:
+int  __anon_vma_prepare(struct vm_area_struct *);

ERROR: "foo * bar" should be "foo *bar"
#50: FILE: include/linux/rmap.h:145:
+static inline int anon_vma_prepare(struct vm_area_struct * vma)

total: 1 errors, 1 warnings, 118 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-rmap-handle-anon_vma_prepare-common-case-inline.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rmap.h~mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes
+++ a/include/linux/rmap.h
@@ -142,7 +142,7 @@ void unlink_anon_vmas(struct vm_area_str
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 
-static inline int anon_vma_prepare(struct vm_area_struct * vma)
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
 {
 	if (likely(vma->anon_vma))
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

