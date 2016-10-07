From: akpm@linux-foundation.org
Subject: [folded-merged]
 seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:43:17 -0700
Message-ID: <57f83315.M9qePgowpunXe73L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755220AbcJGXnZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, joe@perches.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix
has been removed from the -mm tree.  Its filename was
     seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch

This patch was dropped because it was folded into seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch

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
@@ -1515,7 +1515,7 @@ static int vmstat_show(struct seq_file *
 	unsigned long off = l - (unsigned long *)m->private;
 
 	seq_puts(m, vmstat_text[off]);
-	seq_put_decimal_ull(m, ' ', *l);
+	seq_put_decimal_ull(m, " ", *l);
 	seq_putc(m, '\n');
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
a.patch

