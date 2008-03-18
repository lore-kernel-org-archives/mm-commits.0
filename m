From: akpm@linux-foundation.org
Subject: + mm-readhead-fix-kernel-doc-notation.patch added to -mm tree
Date: Tue, 18 Mar 2008 15:47:33 -0700
Message-ID: <200803182247.m2IMlXYb020022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757899AbYCSTmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mm/readhead: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     mm-readhead-fix-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/readhead: fix kernel-doc notation
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

mm-fix-various-kernel-doc-comments.patch
mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch
mm-oom_kill-fix-kernel-doc.patch
mm-highmem-kernel-doc-additions.patch
mm-rmap-kernel-doc-fixes.patch
jbd-fix-jbd-kernel-doc-notation.patch
fs-fix-kernel-doc-notation-warnings.patch
mm-readhead-fix-kernel-doc-notation.patch
x86-convert-mtrr-genericc-to-kernel-doc.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
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
profile-likely-unlikely-macros.patch

