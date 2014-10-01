From: akpm@linux-foundation.org
Subject: + fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch added
 to -mm tree
Date: Wed, 01 Oct 2014 15:29:44 -0700
Message-ID: <542c8058.SKgkMQfGgZvv/Omp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaJAW3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, petr@vandrovec.name, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ncpfs/dir.c: remove redundant sys_tz declaration
has been added to the -mm tree.  Its filename is
     fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch

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
Subject: fs/ncpfs/dir.c: remove redundant sys_tz declaration

sys_tz is already declared in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ncpfs/dir.c~fs-ncpfs-dirc-remove-redundant-sys_tz-declaration fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~fs-ncpfs-dirc-remove-redundant-sys_tz-declaration
+++ a/fs/ncpfs/dir.c
@@ -1182,9 +1182,6 @@ static int day_n[] =
 {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0, 0};
 /* Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec */
 
-
-extern struct timezone sys_tz;
-
 static int utc2local(int time)
 {
 	return time - sys_tz.tz_minuteswest * 60;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ufs-ballocc-remove-unused-variable.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
fat-remove-redundant-sys_tz-declaration.patch
fs-affs-superc-remove-unused-variable.patch
fs-affs-inodec-remove-unused-variable.patch
fs-affs-filec-fix-shadow-warnings.patch
fs-omfs-block-number-sanity-check-during-fill_super-operation.patch
linux-next.patch
fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch
fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch
fs-affs-remove-redundant-sys_tz-declarations.patch

