From: akpm@linux-foundation.org
Subject: + atyfb-remove-unused-local-variable-pwr_command.patch added to -mm tree
Date: Fri, 20 Feb 2009 13:57:32 -0800
Message-ID: <200902202157.n1KLvWbs002391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbZBTV5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 16:57:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     atyfb: remove unused local variable `pwr_command'
has been added to the -mm tree.  Its filename is
     atyfb-remove-unused-local-variable-pwr_command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: remove unused local variable `pwr_command'
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/aty/aty128fb.c~atyfb-remove-unused-local-variable-pwr_command drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~atyfb-remove-unused-local-variable-pwr_command
+++ a/drivers/video/aty/aty128fb.c
@@ -2365,7 +2365,6 @@ static void fbcon_aty128_bmove(struct di
 static void aty128_set_suspend(struct aty128fb_par *par, int suspend)
 {
 	u32	pmgt;
-	u16	pwr_command;
 	struct pci_dev *pdev = par->pdev;
 
 	if (!par->pm_reg)
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch
replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch
replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch
replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch
replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch
replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch
replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch
replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch
replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch
replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch
update-the-old-macro-dma_nbit_mask-related-documentations.patch
atyfb-remove-unused-local-variable-pwr_command.patch

