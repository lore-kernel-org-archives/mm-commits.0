From: akpm@linux-foundation.org
Subject: +
 seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
 added to -mm tree
Date: Tue, 09 Aug 2016 16:34:33 -0700
Message-ID: <57aa6889.dNO6AePxr3Eh9cWR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbcHIXee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 19:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, joe@perches.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix
has been added to the -mm tree.  Its filename is
     seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix

update vmstat_show(), per Joe

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix mm/vmstat.c
--- a/mm/vmstat.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix
+++ a/mm/vmstat.c
@@ -1594,7 +1594,7 @@ static int vmstat_show(struct seq_file *
 	unsigned long off = l - (unsigned long *)m->private;
 
 	seq_puts(m, vmstat_text[off]);
-	seq_put_decimal_ull(m, ' ', *l);
+	seq_put_decimal_ull(m, " ", *l);
 	seq_putc(m, '\n');
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-arm-keystone-dts-add-psci-command-definition.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

