From: akpm@linux-foundation.org
Subject: - lguest-should-depend-on-config_futex.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:53 -0700
Message-ID: <200708242058.l7OKwrfT014341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762426AbXHXVIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest should depend on CONFIG_FUTEX
has been removed from the -mm tree.  Its filename was
     lguest-should-depend-on-config_futex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest should depend on CONFIG_FUTEX
From: Alexey Dobriyan <adobriyan@sw.ru>

It uses get_futex_key().

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/Kconfig~lguest-should-depend-on-config_futex drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig~lguest-should-depend-on-config_futex
+++ a/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE
+	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE && FUTEX
 	select LGUEST_GUEST
 	select HVC_DRIVER
 	---help---
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-ver_linux-glibc-version-printing.patch
userns-dont-leak-root-user.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
single_open-seq_release-leak-diagnostics.patch
