From: akpm@linux-foundation.org
Subject: - add-documentation-block-00-index.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:46:12 -0700
Message-ID: <200710162046.l9GKkCVT016342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965838AbXJPU5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Add Documentation/block/00-INDEX
has been removed from the -mm tree.  Its filename was
     add-documentation-block-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add Documentation/block/00-INDEX
From: Rob Landley <rob@landley.net>

Add Documentation/block/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/00-INDEX |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN /dev/null Documentation/block/00-INDEX
--- /dev/null
+++ a/Documentation/block/00-INDEX
@@ -0,0 +1,20 @@
+00-INDEX
+	- This file
+as-iosched.txt
+	- Anticipatory IO scheduler
+barrier.txt
+	- I/O Barriers
+biodoc.txt
+	- Notes on the Generic Block Layer Rewrite in Linux 2.5
+capability.txt
+	- Generic Block Device Capability (/sys/block/<disk>/capability)
+deadline-iosched.txt
+	- Deadline IO scheduler tunables
+ioprio.txt
+	- Block io priorities (in CFQ scheduler)
+request.txt
+	- The members of struct request (in include/linux/blkdev.h)
+stat.txt
+	- Block layer statistics in /sys/block/<dev>/stat
+switching-sched.txt
+	- Switching I/O schedulers at runtime
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
add-documentation-w1w1-masters-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
add-recommended-section-ids-to-deviceiobooktmpl.patch
add-documentation-rcu-00-index.patch
fix-make-htmldocs-build-break.patch
add-section-ids-to-documentation-docbook-filesystemstmpl.patch
