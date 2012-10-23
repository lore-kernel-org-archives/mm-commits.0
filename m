From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-add-printk_syslogc-and-h-fix.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:53 -0700
Message-ID: <20121023200453.AA5DE100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60997 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933613Ab2JWUEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:54 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so114855qae.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, kay@vrfy.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-add-printk_syslogc-and-h-fix
has been removed from the -mm tree.  Its filename was
     printk-add-printk_syslogc-and-h-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-add-printk_syslogc-and-h-fix

Cc: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk_syslog.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/printk/printk_syslog.c~printk-add-printk_syslogc-and-h-fix kernel/printk/printk_syslog.c
--- a/kernel/printk/printk_syslog.c~printk-add-printk_syslogc-and-h-fix
+++ a/kernel/printk/printk_syslog.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/uaccess.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

