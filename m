From: akpm@linux-foundation.org
Subject: - mm-make-needlessly-global-hugetlb_no_page-static.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:38 -0700
Message-ID: <200707172301.l6HN1cJr011419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936059AbXGQXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     MM: Make needlessly global hugetlb_no_page() static.
has been removed from the -mm tree.  Its filename was
     mm-make-needlessly-global-hugetlb_no_page-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MM: Make needlessly global hugetlb_no_page() static.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-make-needlessly-global-hugetlb_no_page-static mm/hugetlb.c
--- a/mm/hugetlb.c~mm-make-needlessly-global-hugetlb_no_page-static
+++ a/mm/hugetlb.c
@@ -498,7 +498,7 @@ static int hugetlb_cow(struct mm_struct 
 	return VM_FAULT_MINOR;
 }
 
-int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
+static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, int write_access)
 {
 	int ret = VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
