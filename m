From: akpm@linux-foundation.org
Subject: - arch-um-kernel-initrdc-fix-a-missed-conversion-specifier.patch removed from -mm tree
Date: Thu, 14 Feb 2008 22:39:57 -0800
Message-ID: <200802150639.m1F6dvBM024147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbYBOGkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 01:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@karaya.com, mm-commits@vger.kernel.org


The patch titled
     arch/um/kernel/initrd.c: fix a missed conversion specifier
has been removed from the -mm tree.  Its filename was
     arch-um-kernel-initrdc-fix-a-missed-conversion-specifier.patch

This patch was dropped because I already had it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/kernel/initrd.c: fix a missed conversion specifier
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix a missed conversion specifier of a printk in arch/um/kernel/initrd.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Jeff Dike <jdike@karaya.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/initrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/initrd.c~arch-um-kernel-initrdc-fix-a-missed-conversion-specifier arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~arch-um-kernel-initrdc-fix-a-missed-conversion-specifier
+++ a/arch/um/kernel/initrd.c
@@ -32,7 +32,7 @@ static int __init read_initrd(void)
 	 * ask for no memory.
 	 */
 	if (size == 0) {
-		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		printk(KERN_ERR "\"%s\" is a zero-size initrd\n", initrd);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-fix-initrd-printk.patch
arch-um-kernel-initrdc-fix-a-missed-conversion-specifier.patch
arch-um-kernel-memc-fix-a-shadowed-variable.patch
