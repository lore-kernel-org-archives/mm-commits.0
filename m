From: akpm@linux-foundation.org
Subject: + m32r-kernel-smpbootc-must-include-linux-cpuh.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:45:39 -0700
Message-ID: <200810161945.m9GJjede009442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbYJPTqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, takata@linux-m32r.org


The patch titled
     m32r/kernel/smpboot.c must #include <linux/cpu.h>
has been added to the -mm tree.  Its filename is
     m32r-kernel-smpbootc-must-include-linux-cpuh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r/kernel/smpboot.c must #include <linux/cpu.h>
From: Adrian Bunk <bunk@kernel.org>

arch/m32r/kernel/smpboot.c: In function 'smp_online':
arch/m32r/kernel/smpboot.c:501: error: implicit declaration of function 'notify_cpu_starting'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smpboot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/kernel/smpboot.c~m32r-kernel-smpbootc-must-include-linux-cpuh arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-kernel-smpbootc-must-include-linux-cpuh
+++ a/arch/m32r/kernel/smpboot.c
@@ -48,6 +48,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/delay.h>
+#include <linux/cpu.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
ipc-semc-make-free_un-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

