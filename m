From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-streec-remove-obsolete-__constant.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:40:08 -0700
Message-ID: <53960d98.OzsYZKLOvqX3ebie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaFITkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jeffm@suse.com, fabf@skynet.be

Subject: [merged] fs-reiserfs-streec-remove-obsolete-__constant.patch removed from -mm tree
To: fabf@skynet.be,jeffm@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:08 -0700


The patch titled
     Subject: fs/reiserfs/stree.c: remove obsolete __constant
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-streec-remove-obsolete-__constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs/stree.c: remove obsolete __constant

__constant_cpu_to_le32 converted to cpu_to_le32

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/stree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/stree.c~fs-reiserfs-streec-remove-obsolete-__constant fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~fs-reiserfs-streec-remove-obsolete-__constant
+++ a/fs/reiserfs/stree.c
@@ -228,10 +228,10 @@ const struct reiserfs_key MIN_KEY = { 0,
 
 /* Maximal possible key. It is never in the tree. */
 static const struct reiserfs_key MAX_KEY = {
-	__constant_cpu_to_le32(0xffffffff),
-	__constant_cpu_to_le32(0xffffffff),
-	{{__constant_cpu_to_le32(0xffffffff),
-	  __constant_cpu_to_le32(0xffffffff)},}
+	cpu_to_le32(0xffffffff),
+	cpu_to_le32(0xffffffff),
+	{{cpu_to_le32(0xffffffff),
+	  cpu_to_le32(0xffffffff)},}
 };
 
 /* Get delimiting key of the buffer by looking for it in the buffers in the path, starting from the bottom
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

