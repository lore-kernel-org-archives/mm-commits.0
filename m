From: akpm@linux-foundation.org
Subject: - fbdev-geforce-7300-cleanup.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:32 -0700
Message-ID: <200705120535.l4C5ZWIH002302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbXELFfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: geforce 7300 cleanup
has been removed from the -mm tree.  Its filename was
     fbdev-geforce-7300-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: geforce 7300 cleanup
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

ups... coding style.

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_hw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/nvidia/nv_hw.c~fbdev-geforce-7300-cleanup drivers/video/nvidia/nv_hw.c
--- a/drivers/video/nvidia/nv_hw.c~fbdev-geforce-7300-cleanup
+++ a/drivers/video/nvidia/nv_hw.c
@@ -149,7 +149,9 @@ static void nvGetClocks(struct nvidia_pa
 		pll = NV_RD32(par->PMC, 0x4024);
 		M = pll & 0xFF;
 		N = (pll >> 8) & 0xFF;
-		if (((par->Chipset & 0xfff0) == 0x0290) || ((par->Chipset & 0xfff0) == 0x0390) || ((par->Chipset & 0xfff0) == 0x02E0)) {
+		if (((par->Chipset & 0xfff0) == 0x0290) ||
+			((par->Chipset & 0xfff0) == 0x0390) ||
+			((par->Chipset & 0xfff0) == 0x02E0)) {
 			MB = 1;
 			NB = 1;
 		} else {
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
xfs-fix-unmount-race.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
