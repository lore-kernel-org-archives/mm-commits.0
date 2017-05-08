From: akpm@linux-foundation.org
Subject: [patch 064/114] scripts/spelling.txt: add "memory" pattern
 and fix typos
Date: Mon, 08 May 2017 15:57:47 -0700
Message-ID: <20170508225747.10q0FYKCS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdEHW5s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, sboyd@codeaurora.org, torvalds@linux-foundation.org

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: scripts/spelling.txt: add "memory" pattern and fix typos

Fix typos and add the following to the scripts/spelling.txt:

      momery||memory

Link: http://lkml.kernel.org/r/20170317011131.6881-1-sboyd@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    2 +-
 drivers/leds/leds-lp5521.c                 |    2 +-
 drivers/leds/leds-lp5523.c                 |    2 +-
 drivers/leds/leds-lp5562.c                 |    2 +-
 scripts/spelling.txt                       |    1 +
 5 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/infiniband/hw/hns/hns_roce_hw_v1.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos drivers/infiniband/hw/hns/hns_roce_hw_v1.c
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos
+++ a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1721,7 +1721,7 @@ int hns_roce_v1_write_mtpt(void *mb_buf,
 	roce_set_field(mpt_entry->mpt_byte_64, MPT_BYTE_64_L_KEY_IDX_H_M,
 		       MPT_BYTE_64_L_KEY_IDX_H_S, mtpt_idx >> MTPT_IDX_SHIFT);
 
-	/* DMA momery regsiter */
+	/* DMA memory regsiter */
 	if (mr->type == MR_TYPE_DMA)
 		return 0;
 
diff -puN drivers/leds/leds-lp5521.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos
+++ a/drivers/leds/leds-lp5521.c
@@ -281,7 +281,7 @@ static void lp5521_firmware_loaded(struc
 	}
 
 	/*
-	 * Program momery sequence
+	 * Program memory sequence
 	 *  1) set engine mode to "LOAD"
 	 *  2) write firmware data into program memory
 	 */
diff -puN drivers/leds/leds-lp5523.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos
+++ a/drivers/leds/leds-lp5523.c
@@ -387,7 +387,7 @@ static void lp5523_firmware_loaded(struc
 	}
 
 	/*
-	 * Program momery sequence
+	 * Program memory sequence
 	 *  1) set engine mode to "LOAD"
 	 *  2) write firmware data into program memory
 	 */
diff -puN drivers/leds/leds-lp5562.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos drivers/leds/leds-lp5562.c
--- a/drivers/leds/leds-lp5562.c~scripts-spellingtxt-add-memory-pattern-and-fix-typos
+++ a/drivers/leds/leds-lp5562.c
@@ -270,7 +270,7 @@ static void lp5562_firmware_loaded(struc
 	}
 
 	/*
-	 * Program momery sequence
+	 * Program memory sequence
 	 *  1) set engine mode to "LOAD"
 	 *  2) write firmware data into program memory
 	 */
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-memory-pattern-and-fix-typos scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-memory-pattern-and-fix-typos
+++ a/scripts/spelling.txt
@@ -691,6 +691,7 @@ miximum||maximum
 mmnemonic||mnemonic
 mnay||many
 modulues||modules
+momery||memory
 monochorome||monochrome
 monochromo||monochrome
 monocrome||monochrome
_
