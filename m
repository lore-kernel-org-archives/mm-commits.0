From: akpm@osdl.org
Subject: - fs-ufs-add-missing-bracket.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:07 -0800
Message-ID: <200612072316.kB7NG73Q030781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53606 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163829AbWLGXQP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     fs: ufs add missing bracket
has been removed from the -mm tree.  Its filename was
     fs-ufs-add-missing-bracket.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: ufs add missing bracket
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/util.h~fs-ufs-add-missing-bracket fs/ufs/util.h
--- a/fs/ufs/util.h~fs-ufs-add-missing-bracket
+++ a/fs/ufs/util.h
@@ -299,7 +299,7 @@ static inline void *get_usb_offset(struc
 
 #define ubh_get_addr16(ubh,begin) \
 	(((__fs16*)((ubh)->bh[(begin) >> (uspi->s_fshift-1)]->b_data)) + \
-	((begin) & (uspi->fsize>>1) - 1)))
+	((begin) & ((uspi->fsize>>1) - 1)))
 
 #define ubh_get_addr32(ubh,begin) \
 	(((__fs32*)((ubh)->bh[(begin) >> (uspi->s_fshift-2)]->b_data)) + \
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch
video-cyberfb-broken-macro-removal.patch
video-neofb-stray-bracket-fix.patch
video-pm3fb-macros-fix.patch

