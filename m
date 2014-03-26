From: akpm@linux-foundation.org
Subject: + maintainers-remove-venkatesh-from-hpet-move-to-credits.patch
 added to -mm tree
Date: Wed, 26 Mar 2014 15:16:50 -0700
Message-ID: <533351d2.yRbJLi8SD5Fw/Kf/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaCZWQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 18:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, joe@perches.com

Subject: + maintainers-remove-venkatesh-from-hpet-move-to-credits.patch added to -mm tree
To: joe@perches.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 15:16:50 -0700


The patch titled
     Subject: MAINTAINERS: remove Venkatesh from HPET, move to CREDITS
has been added to the -mm tree.  Its filename is
     maintainers-remove-venkatesh-from-hpet-move-to-credits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-venkatesh-from-hpet-move-to-credits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-venkatesh-from-hpet-move-to-credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove Venkatesh from HPET, move to CREDITS

Seems he's gone off to bigger/better things.  So long, etc...

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    3 +++
 MAINTAINERS |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN CREDITS~maintainers-remove-venkatesh-from-hpet-move-to-credits CREDITS
--- a/CREDITS~maintainers-remove-venkatesh-from-hpet-move-to-credits
+++ a/CREDITS
@@ -2707,6 +2707,9 @@ N: Greg Page
 E: gpage@sovereign.org
 D: IPX development and support
 
+N: Venkatesh Pallipadi (Venki)
+D: x86/HPET
+
 N: David Parsons
 E: orc@pell.chi.il.us
 D: improved memory detection code.
diff -puN MAINTAINERS~maintainers-remove-venkatesh-from-hpet-move-to-credits MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-venkatesh-from-hpet-move-to-credits
+++ a/MAINTAINERS
@@ -4104,8 +4104,7 @@ F:	include/linux/hpet.h
 F:	include/uapi/linux/hpet.h
 
 HPET:	x86
-M:	"Venkatesh Pallipadi (Venki)" <venki@google.com>
-S:	Maintained
+S:	Orphan
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 
_

Patches currently in -mm which might be from joe@perches.com are

ntfs-logging-clean-up.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
maintainers-addition-of-dialog-semiconductor-files.patch
maintainers-remove-venkatesh-from-hpet-move-to-credits.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
checkpatch-improve-octal-permissions-test-speed.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
linux-next.patch

