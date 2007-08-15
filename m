From: akpm@linux-foundation.org
Subject: + m68k-asm-pageh-needs-linux-compilerh.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:07 -0700
Message-ID: <200708152118.l7FLI7iG015463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760250AbXHOVSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: <asm/page.h> needs <linux/compiler.h>
has been added to the -mm tree.  Its filename is
     m68k-asm-pageh-needs-linux-compilerh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: <asm/page.h> needs <linux/compiler.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: <asm/page.h> needs <linux/compiler.h> because of __attribute_const__

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/page.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/asm-m68k/page.h~m68k-asm-pageh-needs-linux-compilerh include/asm-m68k/page.h
--- a/include/asm-m68k/page.h~m68k-asm-pageh-needs-linux-compilerh
+++ a/include/asm-m68k/page.h
@@ -27,6 +27,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
+
 #include <asm/module.h>
 
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
