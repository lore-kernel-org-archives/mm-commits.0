From: akpm@linux-foundation.org
Subject: + fs-affs-bitmapc-remove-unnecessary-return.patch added to -mm
 tree
Date: Thu, 05 Feb 2015 15:19:22 -0800
Message-ID: <54d3fa7a.qugLTX0sWAZBzXbS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbBEXTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2015 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/bitmap.c: remove unnecessary return
has been added to the -mm tree.  Its filename is
     fs-affs-bitmapc-remove-unnecessary-return.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-bitmapc-remove-unnecessary-return.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-bitmapc-remove-unnecessary-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/bitmap.c: remove unnecessary return

return is not needed at the end of function.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/bitmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/affs/bitmap.c~fs-affs-bitmapc-remove-unnecessary-return fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~fs-affs-bitmapc-remove-unnecessary-return
+++ a/fs/affs/bitmap.c
@@ -99,7 +99,6 @@ err_bh_read:
 
 err_range:
 	affs_error(sb, "affs_free_block","Block %u outside partition", block);
-	return;
 }
 
 /*
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
ocfs2-make-resv_lock-spinlock-static.patch
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

