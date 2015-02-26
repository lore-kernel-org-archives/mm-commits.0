From: akpm@linux-foundation.org
Subject: + microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
 added to -mm tree
Date: Thu, 26 Feb 2015 12:36:47 -0800
Message-ID: <54ef83df.EL8/+yibEwkF82v9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbbBZUgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 15:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch

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
Subject: microblaze: mb: Remove use of seq_printf return value

Remove errant x char after tab found by kbuild test robot

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/cpu/mb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/microblaze/kernel/cpu/mb.c~microblaze-mb-remove-use-of-seq_printf-return-value-fix arch/microblaze/kernel/cpu/mb.c
--- a/arch/microblaze/kernel/cpu/mb.c~microblaze-mb-remove-use-of-seq_printf-return-value-fix
+++ a/arch/microblaze/kernel/cpu/mb.c
@@ -102,7 +102,7 @@ static int show_cpuinfo(struct seq_file
 			   cpuinfo.icache_size >> 10,
 			   cpuinfo.icache_line_length);
 	else
-	x	seq_puts(m, "Icache:\t\tno\n");
+		seq_puts(m, "Icache:\t\tno\n");
 
 	if (cpuinfo.use_dcache) {
 		seq_printf(m,
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

