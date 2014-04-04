From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-venkatesh-from-hpet-move-to-credits.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:12 -0700
Message-ID: <533f08f8.1Ovhc31wwDMEut/Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaDDTdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, joe@perches.com

Subject: [merged] maintainers-remove-venkatesh-from-hpet-move-to-credits.patch removed from -mm tree
To: joe@perches.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:12 -0700


The patch titled
     Subject: MAINTAINERS: remove Venkatesh from HPET, move to CREDITS
has been removed from the -mm tree.  Its filename was
     maintainers-remove-venkatesh-from-hpet-move-to-credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2711,6 +2711,9 @@ N: Greg Page
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
@@ -4155,8 +4155,7 @@ F:	include/linux/hpet.h
 F:	include/uapi/linux/hpet.h
 
 HPET:	x86
-M:	"Venkatesh Pallipadi (Venki)" <venki@google.com>
-S:	Maintained
+S:	Orphan
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 
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

