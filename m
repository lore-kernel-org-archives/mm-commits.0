From: akpm@linux-foundation.org
Subject: - docbook-fix-vmalloc-missing-parameter-notation.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:29 -0700
Message-ID: <200805021942.m42JgTex011196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932164AbYEBTmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbook: fix vmalloc missing parameter notation
has been removed from the -mm tree.  Its filename was
     docbook-fix-vmalloc-missing-parameter-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix vmalloc missing parameter notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix vmalloc kernel-doc warning:

Warning(linux-2.6.25-git14//mm/vmalloc.c:555): No description found for parameter 'caller'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmalloc.c~docbook-fix-vmalloc-missing-parameter-notation mm/vmalloc.c
--- a/mm/vmalloc.c~docbook-fix-vmalloc-missing-parameter-notation
+++ a/mm/vmalloc.c
@@ -547,6 +547,7 @@ void *__vmalloc_area(struct vm_struct *a
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
  *	@node:		node to use for allocation or -1
+ *	@caller:	caller's return address
  *
  *	Allocate enough pages to cover @size from the page level
  *	allocator with @gfp_mask flags.  Map them into contiguous
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
pnp-fix-missing-kernel-doc-notation.patch
x86-fix-setup-printk-format-warning.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-sched.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

