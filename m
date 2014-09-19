From: akpm@linux-foundation.org
Subject: +
 frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch added to -mm tree
Date: Fri, 19 Sep 2014 16:21:02 -0700
Message-ID: <541cba5e.I7ZlChdGkw5Rshp6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaISXVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 19:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: remove unused declarations of __start___ex_table and __stop___ex_table
has been added to the -mm tree.  Its filename is
     frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: frv: remove unused declarations of __start___ex_table and __stop___ex_table

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/extable.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/frv/mm/extable.c~frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table arch/frv/mm/extable.c
--- a/arch/frv/mm/extable.c~frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table
+++ a/arch/frv/mm/extable.c
@@ -6,8 +6,6 @@
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
 
-extern const struct exception_table_entry __attribute__((aligned(8))) __start___ex_table[];
-extern const struct exception_table_entry __attribute__((aligned(8))) __stop___ex_table[];
 extern const void __memset_end, __memset_user_error_lr, __memset_user_error_handler;
 extern const void __memcpy_end, __memcpy_user_error_lr, __memcpy_user_error_handler;
 extern spinlock_t modlist_lock;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
alpha-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
include-linux-screen_infoh-remove-unused-orig_-macros.patch
nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
linux-next.patch
frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch
ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end.patch
kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch

