From: akpm@linux-foundation.org
Subject: + reiserfs-fix-sparse-warning-in-journalc.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:22 -0800
Message-ID: <200802230736.m1N7aBTv018414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbYBWHy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     reiserfs: fix sparse warning in journal.c
has been added to the -mm tree.  Its filename is
     reiserfs-fix-sparse-warning-in-journalc.patch

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
Subject: reiserfs: fix sparse warning in journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/reiserfs/journal.c:4319:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/journal.c~reiserfs-fix-sparse-warning-in-journalc fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-fix-sparse-warning-in-journalc
+++ a/fs/reiserfs/journal.c
@@ -4316,5 +4316,5 @@ static void __reiserfs_journal_abort_sof
 
 void reiserfs_journal_abort(struct super_block *sb, int errno)
 {
-	return __reiserfs_journal_abort_soft(sb, errno);
+	__reiserfs_journal_abort_soft(sb, errno);
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
markers-fix-sparse-warnings-in-markersc.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
