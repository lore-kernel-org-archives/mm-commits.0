From: akpm@osdl.org
Subject: - dont-export-asm-pageh-to-userspace.patch removed from -mm tree
Date: Thu, 04 Jan 2007 21:13:15 -0800
Message-ID: <200701050513.l055DGIg010165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54044 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312AbXAEFNU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 00:13:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     dont export asm/page.h to userspace
has been removed from the -mm tree.  Its filename was
     dont-export-asm-pageh-to-userspace.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: dont export asm/page.h to userspace
From: Mike Frysinger <vapier@gentoo.org>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/Kbuild.asm |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-generic/Kbuild.asm~dont-export-asm-pageh-to-userspace include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~dont-export-asm-pageh-to-userspace
+++ a/include/asm-generic/Kbuild.asm
@@ -32,4 +32,3 @@ unifdef-y += user.h
 # These probably shouldn't be exported
 unifdef-y += shmparam.h
 unifdef-y += elf.h
-unifdef-y += page.h
_

Patches currently in -mm which might be from vapier@gentoo.org are

dont-export-asm-pageh-to-userspace.patch
search-a-little-harder-for-mkimage.patch
