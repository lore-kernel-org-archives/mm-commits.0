From: akpm@linux-foundation.org
Subject: - hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:14 -0700
Message-ID: <200710180701.l9I71ElZ031161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761833AbXJRHQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     HVC console is also used by iSeries, so add that to HVC_DRIVER help.
has been removed from the -mm tree.  Its filename was
     hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HVC console is also used by iSeries, so add that to HVC_DRIVER help.
From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help drivers/char/Kconfig
--- a/drivers/char/Kconfig~hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help
+++ a/drivers/char/Kconfig
@@ -586,7 +586,7 @@ config HVC_DRIVER
 	bool
 	help
 	  Generic "hypervisor virtual console" infrastructure for various
-	  hypervisors (pSeries, Xen, lguest).
+	  hypervisors (pSeries, iSeries, Xen, lguest).
 	  It will automatically be selected if one of the back-end console drivers
 	  is selected.
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-x86.patch
update-boot-spec-to-207.patch
add-weak-for-creating-weak-asm-labels.patch
i386-paravirt-boot-sequence.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
