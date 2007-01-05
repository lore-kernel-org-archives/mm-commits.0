From: akpm@osdl.org
Subject: + dont-export-asm-pageh-to-userspace.patch added to -mm tree
Date: Thu, 04 Jan 2007 19:36:28 -0800
Message-ID: <200701050336.l053aT9f008348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49406 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030305AbXAEDi0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 22:38:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     dont export asm/page.h to userspace
has been added to the -mm tree.  Its filename is
     dont-export-asm-pageh-to-userspace.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
