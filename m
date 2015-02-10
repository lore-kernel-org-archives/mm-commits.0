From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
 removed from -mm tree
Date: Tue, 10 Feb 2015 14:02:21 -0800
Message-ID: <54da7fed.hPxPUMngTSY0m+yU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbbBJWCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 17:02:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch

This patch was dropped because it was folded into mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix

fix filemap_xip.c

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/filemap_xip.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix
+++ a/mm/filemap_xip.c
@@ -301,7 +301,6 @@ out:
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
 	.page_mkwrite	= filemap_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch

