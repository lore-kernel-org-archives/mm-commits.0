From: akpm@linux-foundation.org
Subject: - mm-readhead-fix-kernel-doc-notation.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:52 -0700
Message-ID: <200803212029.m2LKTq3H008904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759617AbYCUUas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm/readahead: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     mm-readhead-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/readahead: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in mm/readahead.c.

Change ":" to ";" so that it doesn't get treated as a doc section heading. 
Move the comment block ending "*/" to a line by itself so that the text on
that last line is not lost (dropped).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/readahead.c~mm-readhead-fix-kernel-doc-notation mm/readahead.c
--- a/mm/readahead.c~mm-readhead-fix-kernel-doc-notation
+++ a/mm/readahead.c
@@ -443,9 +443,10 @@ EXPORT_SYMBOL_GPL(page_cache_sync_readah
  *            pagecache pages
  *
  * page_cache_async_ondemand() should be called when a page is used which
- * has the PG_readahead flag: this is a marker to suggest that the application
+ * has the PG_readahead flag; this is a marker to suggest that the application
  * has used up enough of the readahead window that we should start pulling in
- * more pages. */
+ * more pages.
+ */
 void
 page_cache_async_readahead(struct address_space *mapping,
 			   struct file_ra_state *ra, struct file *filp,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

