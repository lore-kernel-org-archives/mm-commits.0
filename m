From: akpm@linux-foundation.org
Subject: [folded-merged]
 microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 15:47:00 -0700
Message-ID: <552eea64.nYytMU7e4Kr/T/cx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbDOWrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: mb: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch

This patch was dropped because it was folded into microblaze-mb-remove-use-of-seq_printf-return-value.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: microblaze: mb: remove use of seq_printf return value

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

origin.patch
maintainers-use-tabs-consistently.patch
maintainers-credits-remove-stefano-brivio-from-b43.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch

