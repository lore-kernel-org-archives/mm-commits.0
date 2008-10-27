From: akpm@linux-foundation.org
Subject: + mm-fix-kernel-doc-function-notation.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:15:42 -0700
Message-ID: <200810272015.m9RKFg11011515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYJ0UQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mm: fix kernel-doc function notation
has been added to the -mm tree.  Its filename is
     mm-fix-kernel-doc-function-notation.patch

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
Subject: mm: fix kernel-doc function notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in mm/ subdirectory.
Actually this is a kernel-doc notation fix.

Warning(/var/linsrc/linux-2.6.27-git10//mm/vmalloc.c:902): Excess function parameter or struct member 'returns' description in 'vm_map_ram'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-fix-kernel-doc-function-notation mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-kernel-doc-function-notation
+++ a/mm/vmalloc.c
@@ -897,7 +897,8 @@ EXPORT_SYMBOL(vm_unmap_ram);
  * @count: number of pages
  * @node: prefer to allocate data structures on this node
  * @prot: memory protection to use. PAGE_KERNEL for regular RAM
- * @returns: a pointer to the address that has been mapped, or NULL on failure
+ *
+ * Returns: a pointer to the address that has been mapped, or %NULL on failure
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t prot)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

