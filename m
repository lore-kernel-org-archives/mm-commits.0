From: akpm@linux-foundation.org
Subject: - fbdev-move-arch-specific-bits-to-their-respective-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:43:50 -0700
Message-ID: <200707092343.l69Nho84021002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758670AbXGIXoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bob.picco@hp.com, adaplas@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     fbdev-move-arch-specific-bits-to-their-respective fix
has been removed from the -mm tree.  Its filename was
     fbdev-move-arch-specific-bits-to-their-respective-fix.patch

This patch was dropped because it was folded into fbdev-move-arch-specific-bits-to-their-respective.patch

------------------------------------------------------
Subject: fbdev-move-arch-specific-bits-to-their-respective fix
From: "Bob Picco" <bob.picco@hp.com>

More build breakage. efi_range_is_wc is referenced but not declared.

Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/fb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-ia64/fb.h~fbdev-move-arch-specific-bits-to-their-respective-fix include/asm-ia64/fb.h
--- a/include/asm-ia64/fb.h~fbdev-move-arch-specific-bits-to-their-respective-fix
+++ a/include/asm-ia64/fb.h
@@ -2,6 +2,7 @@
 #define _ASM_FB_H_
 
 #include <linux/fs.h>
+#include <linux/efi.h>
 #include <asm/page.h>
 
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from bob.picco@hp.com are

git-kgdb.patch
move-free-pages-between-lists-on-steal.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
lumpy-reclaim-v4.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-move-arch-specific-bits-to-their-respective-fix.patch
