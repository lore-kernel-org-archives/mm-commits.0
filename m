From: akpm@linux-foundation.org
Subject: [merged] ocfs2-make-resv_lock-spinlock-static.patch removed from
 -mm tree
Date: Wed, 11 Feb 2015 12:21:26 -0800
Message-ID: <54dbb9c6.wOmxoVzUoMAb0BXy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbBKUV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: make resv_lock spinlock static
has been removed from the -mm tree.  Its filename was
     ocfs2-make-resv_lock-spinlock-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: make resv_lock spinlock static

resv_lock is only used in reservations.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/reservations.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/reservations.c~ocfs2-make-resv_lock-spinlock-static fs/ocfs2/reservations.c
--- a/fs/ocfs2/reservations.c~ocfs2-make-resv_lock-spinlock-static
+++ a/fs/ocfs2/reservations.c
@@ -39,7 +39,7 @@
 #define OCFS2_CHECK_RESERVATIONS
 #endif
 
-DEFINE_SPINLOCK(resv_lock);
+static DEFINE_SPINLOCK(resv_lock);
 
 #define	OCFS2_MIN_RESV_WINDOW_BITS	8
 #define	OCFS2_MAX_RESV_WINDOW_BITS	1024
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
add-another-clock-for-use-with-the-soft-lockup-watchdog.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-coda-dirc-forward-declaration-clean-up.patch
fs-ufs-superc-remove-unnecessary-casting.patch
fs-ufs-superc-fix-potential-race-condition.patch
fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
fs-affs-use-unsigned-int-for-string-lengths.patch
define-affsnamemax-to-replace-constant-use.patch
fs-affs-amigaffsc-remove-else-after-return.patch
fs-affs-bitmapc-remove-unnecessary-return.patch
fs-affs-inodec-remove-double-extern-affs_symlink_inode_operations.patch
fs-affs-superc-fix-switch-indentation.patch
linux-next.patch

