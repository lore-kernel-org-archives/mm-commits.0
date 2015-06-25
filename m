From: akpm@linux-foundation.org
Subject: [folded-merged] zswap-runtime-enable-disable-fix.patch removed
 from -mm tree
Date: Thu, 25 Jun 2015 14:50:12 -0700
Message-ID: <558c7794./V1h7uNfmMZYBHtH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbFYVuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-runtime-enable-disable-fix
has been removed from the -mm tree.  Its filename was
     zswap-runtime-enable-disable-fix.patch

This patch was dropped because it was folded into zswap-runtime-enable-disable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-runtime-enable-disable-fix

tweak documentation

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/vm/zswap.txt~zswap-runtime-enable-disable-fix Documentation/vm/zswap.txt
--- a/Documentation/vm/zswap.txt~zswap-runtime-enable-disable-fix
+++ a/Documentation/vm/zswap.txt
@@ -27,21 +27,21 @@ device when the compressed pool reaches
 been identified in prior community discussions.
 
 Zswap is disabled by default but can be enabled at boot time by setting
-the "enabled" attribute to 1 at boot time. e.g. zswap.enabled=1. Zswap
+the "enabled" attribute to 1 at boot time. ie: zswap.enabled=1.  Zswap
 can also be enabled and disabled at runtime using the sysfs interface.
-An exmaple command to enable zswap at runtime, assuming sysfs is mounted
+An example command to enable zswap at runtime, assuming sysfs is mounted
 at /sys, is:
 
 echo 1 > /sys/modules/zswap/parameters/enabled
 
-When zswap is disabled at runtime, it will stop storing pages that are
-being swapped out. However, it will _not_ immediately write out or
-fault back into memory all of the pages stored in the compressed pool.
-The pages stored in zswap will continue to remain in the compressed pool
-until they are either invalidated or faulted back into memory. In order
-to force all pages out of the compressed pool, a swapoff on the swap
-device(s) will fault all swapped out pages, included those in the
-compressed pool, back into memory.
+When zswap is disabled at runtime it will stop storing pages that are
+being swapped out.  However, it will _not_ immediately write out or fault
+back into memory all of the pages stored in the compressed pool.  The
+pages stored in zswap will remain in the compressed pool until they are
+either invalidated or faulted back into memory.  In order to force all
+pages out of the compressed pool, a swapoff on the swap device(s) will
+fault back into memory all swapped out pages, including those in the
+compressed pool.
 
 Design:
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
s390-mm-change-hpage_shift-type-to-int.patch
zswap-runtime-enable-disable.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch

