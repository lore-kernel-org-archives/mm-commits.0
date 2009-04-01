From: akpm@linux-foundation.org
Subject: [merged] arkfb-fix-misplaced-parentheses.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:50 -0700
Message-ID: <200904011843.n31IhoVu010218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757924AbZDAT1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     arkfb: fix misplaced parentheses
has been removed from the -mm tree.  Its filename was
     arkfb-fix-misplaced-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arkfb: fix misplaced parentheses
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-fix-misplaced-parentheses drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-fix-misplaced-parentheses
+++ a/drivers/video/arkfb.c
@@ -470,7 +470,7 @@ static void ark_dac_read_regs(void *data
 
 	while (count != 0)
 	{
-		vga_wseq(NULL, 0x1C, regval | (code[0] & 4) ? 0x80 : 0);
+		vga_wseq(NULL, 0x1C, regval | (code[0] & 4 ? 0x80 : 0));
 		code[1] = vga_r(NULL, dac_regs[code[0] & 3]);
 		count--;
 		code += 2;
@@ -485,7 +485,7 @@ static void ark_dac_write_regs(void *dat
 
 	while (count != 0)
 	{
-		vga_wseq(NULL, 0x1C, regval | (code[0] & 4) ? 0x80 : 0);
+		vga_wseq(NULL, 0x1C, regval | (code[0] & 4 ? 0x80 : 0));
 		vga_w(NULL, dac_regs[code[0] & 3], code[1]);
 		count--;
 		code += 2;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

