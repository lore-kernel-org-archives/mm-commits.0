From: akpm@linux-foundation.org
Subject: [folded-merged]
 bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch removed from -mm tree
Date: Thu, 25 Jun 2015 14:53:29 -0700
Message-ID: <558c7859.v/wYHDNOeyBTheaq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbFYVxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, peterz@infradead.org, sudeep.holla@arm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix
has been removed from the -mm tree.  Its filename was
     bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch

This patch was dropped because it was folded into bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix

tweak comment

Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix lib/bitmap.c
--- a/lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix
+++ a/lib/bitmap.c
@@ -462,8 +462,10 @@ EXPORT_SYMBOL(bitmap_parse_user);
  * Output format is a comma-separated list of decimal numbers and
  * ranges if list is specified or hex digits grouped into comma-separated
  * sets of 8 digits/set. Returns the number of characters written to buf.
- * It is assumed that the buffer passed is atleast PAGE_SIZE and easily
- * accommodate nmaskbits.
+ *
+ * It is assumed that @buf is a pointer into a PAGE_SIZE area and that
+ * sufficient storage remains at @buf to accommodate the
+ * bitmap_print_to_pagebuf() output.
  */
 int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
 			    int nmaskbits)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
s390-mm-change-hpage_shift-type-to-int.patch
zswap-runtime-enable-disable.patch
prctl-more-prctlpr_set_mm_-checks.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch

