From: akpm@linux-foundation.org
Subject: - squash-ipc-warnings.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:47:46 -0700
Message-ID: <200707181847.l6IIllME023451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbXGRSsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:48:23 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l6IIlqMN031735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2007 11:47:53 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     squash-ipc-warnings
has been removed from the -mm tree.  Its filename was
     squash-ipc-warnings.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: squash-ipc-warnings
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~squash-ipc-warnings ipc/msg.c
--- a/ipc/msg.c~squash-ipc-warnings
+++ a/ipc/msg.c
@@ -385,7 +385,7 @@ copy_msqid_from_user(struct msq_setbuf *
 asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 {
 	struct kern_ipc_perm *ipcp;
-	struct msq_setbuf setbuf;
+	struct msq_setbuf setbuf = {};
 	struct msg_queue *msq;
 	int err, version;
 	struct ipc_namespace *ns;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
