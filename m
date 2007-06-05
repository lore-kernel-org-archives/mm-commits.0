From: akpm@linux-foundation.org
Subject: + lguest-the-documentation-example-launcher-example-launcher-fix.patch added to -mm tree
Date: Tue, 05 Jun 2007 14:13:45 -0700
Message-ID: <200706052113.l55LDjvA003104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765743AbXFEVN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 17:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: example launcher fix
has been added to the -mm tree.  Its filename is
     lguest-the-documentation-example-launcher-example-launcher-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-tsc-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-use-tsc.patch
lguest-use-hrtimers.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
