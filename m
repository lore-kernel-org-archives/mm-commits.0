From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:33:06 -0700
Message-ID: <533f08f2.kqk5sYXHIto4Net4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaDDTdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, inaky.perez-gonzalez@intel.com, geert@linux-m68k.org, joe@perches.com

Subject: [merged] maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch removed from -mm tree
To: joe@perches.com,geert@linux-m68k.org,inaky.perez-gonzalez@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:06 -0700


The patch titled
     Subject: MAINTAINERS: wimax@linuxwimax.org is subscribers-only
has been removed from the -mm tree.  Its filename was
     maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4622,7 +4622,7 @@ F:	arch/x86/kernel/tboot.c
 INTEL WIRELESS WIMAX CONNECTION 2400
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org
+L:     wimax@linuxwimax.org (subscribers-only)
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
@@ -9657,7 +9657,7 @@ F:	drivers/media/rc/winbond-cir.c
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

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
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
linux-next.patch

