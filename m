From: akpm@linux-foundation.org
Subject: + maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch added to -mm tree
Date: Tue, 11 Mar 2014 14:20:28 -0700
Message-ID: <531f7e1c.b/9fGFWTAUwAnUci%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaCKVU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 17:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, inaky.perez-gonzalez@intel.com, geert@linux-m68k.org, joe@perches.com

Subject: + maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch added to -mm tree
To: joe@perches.com,geert@linux-m68k.org,inaky.perez-gonzalez@intel.com
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 14:20:28 -0700


The patch titled
     Subject: MAINTAINERS: wimax@linuxwimax.org is subscribers-only
has been added to the -mm tree.  Its filename is
     maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch

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
Subject: MAINTAINERS: wimax@linuxwimax.org is subscribers-only

Mark it so.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-wimax-linuxwimaxorg-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~maintainers-wimax-linuxwimaxorg-is-subscribers-only
+++ a/MAINTAINERS
@@ -4592,7 +4592,7 @@ F:	arch/x86/kernel/tboot.c
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org
+L:     wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
@@ -9588,7 +9588,7 @@ F:	drivers/media/rc/winbond-cir.c
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org
+L:     wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.wimax
_

Patches currently in -mm which might be from joe@perches.com are

errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
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
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

