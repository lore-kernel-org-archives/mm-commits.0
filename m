From: akpm@linux-foundation.org
Subject: - gpio-mcp23s08-debug-fix.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:30 -0700
Message-ID: <200805270727.m4R7RUH2014773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283AbYE0HeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: mcp23s08 debug fix
has been removed from the -mm tree.  Its filename was
     gpio-mcp23s08-debug-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: mcp23s08 debug fix
From: Roel Kluin <12o3l@tiscali.nl>

The return value of mcp23s08_read_regs() can only be evaluated when signed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/mcp23s08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/mcp23s08.c~gpio-mcp23s08-debug-fix drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~gpio-mcp23s08-debug-fix
+++ a/drivers/gpio/mcp23s08.c
@@ -168,7 +168,7 @@ static void mcp23s08_dbg_show(struct seq
 {
 	struct mcp23s08	*mcp;
 	char		bank;
-	unsigned	t;
+	int		t;
 	unsigned	mask;
 
 	mcp = container_of(chip, struct mcp23s08, chip);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

linux-next.patch
gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

