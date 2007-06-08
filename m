From: akpm@linux-foundation.org
Subject: - lguest-the-documentation-example-launcher-example-launcher-fix.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:17:43 -0700
Message-ID: <200706080617.l586HhRg021093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbXFHGRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: example launcher fix
has been removed from the -mm tree.  Its filename was
     lguest-the-documentation-example-launcher-example-launcher-fix.patch

This patch was dropped because it was folded into lguest-the-documentation-example-launcher.patch

------------------------------------------------------
Subject: lguest: example launcher fix
From: Rusty Russell <rusty@rustcorp.com.au>

"struct option" arrays handed to getopt_long() are supposed to be
NULL-terminated.  (Another patch added an arg and it finally segv'd).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN Documentation/lguest/lguest.c~lguest-the-documentation-example-launcher-example-launcher-fix Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-the-documentation-example-launcher-example-launcher-fix
+++ a/Documentation/lguest/lguest.c
@@ -930,6 +930,7 @@ static struct option opts[] = {
 	{ "tunnet", 1, NULL, 't' },
 	{ "block", 1, NULL, 'b' },
 	{ "initrd", 1, NULL, 'i' },
+	{ NULL },
 };
 static void usage(void)
 {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
