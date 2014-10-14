From: akpm@linux-foundation.org
Subject: [merged]
 frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:12 -0700
Message-ID: <543d6a10.AvmqwY2nRxP7cA8n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaJNSXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: remove unused declarations of __start___ex_table and __stop___ex_table
has been removed from the -mm tree.  Its filename was
     frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

